# Nostromo Memory API Example

Nostromo is a fictional memory API built with Django Ninja. Use this example when the application already uses Django Ninja. It combines Kaiju's UUID models and user relationships with Squidfall's memory upsert. Keep another application's existing API framework and permission model.

## Source Patterns

These links point to the verified `main` branches and may change as the repositories evolve. The example adapts the inspected source patterns and is not code present in either repository.

| Source | Pattern to reuse |
| --- | --- |
| Kaiju [models](https://github.com/deathlabs/kaiju/blob/main/backend/exercises/models.py), [schemas](https://github.com/deathlabs/kaiju/blob/main/backend/exercises/schemas.py), and [router](https://github.com/deathlabs/kaiju/blob/main/backend/exercises/router.py) | UUID identifiers, timestamps, `settings.AUTH_USER_MODEL`, separate input/output schemas, parent-scoped lookups, and atomic creation of an exercise and its facilitator. |
| Squidfall [models](https://github.com/deathlabs/squidfall/blob/main/backend/squidfall/memories/models.py), [schemas](https://github.com/deathlabs/squidfall/blob/main/backend/squidfall/memories/schemas.py), and [router](https://github.com/deathlabs/squidfall/blob/main/backend/squidfall/memories/router.py) | JSON memory values, a unique namespace/key identity, and `update_or_create()` for replacing a stored value. |
| Kaiju [URL configuration](https://github.com/deathlabs/kaiju/blob/main/backend/kaiju/urls.py) and Squidfall [URL configuration](https://github.com/deathlabs/squidfall/blob/main/backend/squidfall/squidfall/urls.py) | App routers registered on one `NinjaAPI`, mounted at `api/v1/`. |

Kaiju models a related exercise hierarchy. Squidfall stores agent memories and checkpoints. Their common router/schema split does not imply identical domain models or authorization requirements. Kaiju uses `Status(...)` responses, while Squidfall returns status/body tuples. Follow the installed Ninja version and project convention.

## Adapted Memory Endpoint

Assume a Django app named `memories`, Django Ninja with Pydantic 2, and Django's session and authentication middleware. This example deliberately adds per-user ownership and authentication. A namespace is a bounded string here, rather than Squidfall's JSON list, so the unique constraint uses ordinary comparable columns. JSON values remain structured dictionaries.

**Models: `memories/models.py`**

```python
# Standard library imports.
from uuid import uuid4

# Third party imports.
from django.conf import settings
from django.db import models


class Memory(models.Model):
    """Store one named JSON value for a user."""

    id = models.UUIDField(primary_key=True, default=uuid4, editable=False)
    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="memories",
    )
    namespace = models.CharField(max_length=100)
    key = models.CharField(max_length=255)
    value = models.JSONField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        constraints = (
            models.UniqueConstraint(
                fields=["owner", "namespace", "key"],
                name="unique_owner_memory",
            ),
        )
```

**Schemas: `memories/schemas.py`**

```python
# Standard library imports.
from datetime import datetime
from typing import Annotated
from uuid import UUID

# Third party imports.
from ninja import Schema
from pydantic import Field, JsonValue


class MemoryWriteSchema(Schema):
    """Validate the identity and replacement value."""

    namespace: Annotated[str, Field(min_length=1, max_length=100)]
    key: Annotated[str, Field(min_length=1, max_length=255)]
    value: dict[str, JsonValue]


class MemorySchema(MemoryWriteSchema):
    """Return the stored value and server-managed fields."""

    id: UUID
    created_at: datetime
    updated_at: datetime


class NotFoundSchema(Schema):
    """Describe a missing accessible memory."""

    message: str
```

**Router: `memories/router.py`**

```python
# Standard library imports.
from uuid import UUID

# Third party imports.
from django.http import HttpRequest
from ninja import Router
from ninja.security import django_auth

# Local imports.
from memories.models import Memory
from memories.schemas import MemorySchema, MemoryWriteSchema, NotFoundSchema

memory_router = Router(tags=["memories"], auth=django_auth)


@memory_router.post("/", response={200: MemorySchema, 201: MemorySchema})
def put_memory(
    request: HttpRequest,
    payload: MemoryWriteSchema,
) -> tuple[int, Memory]:
    """Create or replace a memory belonging to the authenticated user."""
    memory, created = Memory.objects.update_or_create(
        owner=request.user,
        namespace=payload.namespace,
        key=payload.key,
        defaults={"value": payload.value},
    )
    return (201 if created else 200), memory


@memory_router.get(
    "/{memory_id}/",
    response={200: MemorySchema, 404: NotFoundSchema},
)
def get_memory(
    request: HttpRequest,
    memory_id: UUID,
) -> tuple[int, Memory | dict[str, str]]:
    """Fetch a memory within the authenticated user's scope."""
    try:
        memory = Memory.objects.get(id=memory_id, owner=request.user)
    except Memory.DoesNotExist:
        return 404, {"message": "Memory not found"}
    return 200, memory
```

**Project URLs**

```python
# Third party imports.
from django.urls import path
from ninja import NinjaAPI

# Local imports.
from memories.router import memory_router

api = NinjaAPI()
api.add_router("/memories/", memory_router)

urlpatterns = [path("api/v1/", api.urls)]
```

The request cannot choose `owner`, `id`, or timestamps. Ownership comes from authenticated server state and appears in both the upsert identity and lookup. Another user's UUID returns the same 404 as a missing record. This ownership policy is an example choice, not a claim about the source applications' access policy.

The database constraint enforces the exact identity used by `update_or_create()`, including concurrent inserts. An update replaces the whole JSON value and returns 200, while a new row returns 201. This operation does not merge dictionaries or provide optimistic concurrency control. Django's [QuerySet reference](https://docs.djangoproject.com/en/6.0/ref/models/querysets/#update-or-create) explains the uniqueness requirement. Inspect the target project's installed version before adapting it.

Session authentication requires an existing login flow. Retain session and authentication middleware, and send a valid CSRF token with writes. Django Ninja's [authentication](https://django-ninja.dev/guide/authentication/) and [CSRF guidance](https://django-ninja.dev/guide/csrf/) describe cookie authentication's CSRF checks. For an existing bearer-token service, reuse its verified authenticator instead. Decoding an unsigned token or trusting user-supplied identity is not sufficient authentication.

When adapting Kaiju's related-write pattern, put creation of the parent and required children in one `transaction.atomic()` block. The single-memory upsert above does not need an extra outer block. Add one when additional writes must commit together. Keep foreign-key lookups scoped to both the parent and the user's permitted records, and prefetch relationships when returning nested output schemas.

## Verification When Adapting

Register the app, create and inspect its migration, and use an isolated test database. Adding ownership to an existing Squidfall table requires an explicit backfill and ownership decision for existing rows before making the field required.

Verify that a new identity returns 201, a repeated identity returns 200 with one row and the replacement value, and two users can use the same namespace/key independently. Check that a user cannot read another user's UUID, invalid or oversized identity fields fail validation, and unauthenticated requests fail. Use Django's test client with CSRF checks enabled to verify that session-authenticated writes without a token fail. Test constraint and transaction behavior against the actual database backend when concurrency matters.
