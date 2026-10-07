---
name: python-django
description: Create, revise, or troubleshoot Django applications, models, forms, views, and migrations. Use for changes that depend on Django framework behavior.
---

# Python Django

Read and apply `python` from the active skill catalog or [sibling skill](../python/SKILL.md) for Python style and tooling. Reuse it if already loaded.

Inspect the installed Django version, settings, app configuration, relevant models, URL patterns, views, templates, migrations, and tests before editing. Use documentation for that version. Preserve the project's app boundaries, database backend, authentication model, and deployment configuration.

## Application Behavior

Use Django's ORM, forms, authentication, permissions, and URL reversing rather than recreating them. Keep queries scoped to the requesting user's permitted objects. Preserve CSRF protection and template escaping. Prefer existing view conventions instead of introducing a competing API framework.

Use forms or ModelForms to validate submitted data, then consume `cleaned_data` after `is_valid()`. Put field validation in `clean_<field>()` and cross-field validation in `clean()`, preserving superclass validation when overriding it. Surface validation errors through the form rather than converting them into server errors.

Do not assume `Model.save()` calls `full_clean()`. Validate at the appropriate application boundary and use database constraints for invariants that must survive concurrent writes. Keep ORM queries explicit, avoid accidental repeated evaluation, and use `select_related()` or `prefetch_related()` when the changed path would otherwise issue repeated related-object queries.

## Transactions and Migrations

Use `transaction.atomic()` when related writes must succeed together. Catch database errors outside the affected atomic block so rollback occurs before further queries. Schedule side effects that require committed data with `transaction.on_commit()`. Account for the actual backend when relying on locking or transactional behavior.

Create and inspect migrations for model changes, preserving existing migration history and dependencies. Use historical models from the migration app registry in data migrations. Check reversibility and existing-row handling before adding constraints or required fields.

Use inspection commands such as `showmigrations`, `migrate --plan`, or `sqlmigrate` when appropriate. Do not apply migrations or mutate schema merely to inspect a project. Apply and test migrations only against an authorized database or isolated test database.

## Verification

Use the project's settings and runner. Typical checks are `uv run python manage.py check`, `uv run python manage.py makemigrations --check --dry-run`, and targeted Django tests. Confirm the test database is isolated before running database tests.

Test the changed request, validation failure, permission boundary, or database behavior when warranted. Use Django's test client and database test classes rather than a live deployment. Choose `TransactionTestCase` when the test must observe real transaction boundaries. Report completed checks and database or environment limitations.

## Project Example

Read the [Nostromo memory API example](references/nostromo-memory-example.md) when working on a Django Ninja API with app-level routers, typed schemas, related records, or constrained upserts. It adapts patterns from Kaiju and Squidfall without requiring their architecture for other Django projects.

## Official References

- [Django documentation](https://docs.djangoproject.com/) for the project's installed version.
- [Form validation](https://docs.djangoproject.com/en/6.0/ref/forms/validation/) and [model instance validation](https://docs.djangoproject.com/en/6.0/ref/models/instances/#validating-objects) for validation boundaries.
- [Transactions](https://docs.djangoproject.com/en/6.0/topics/db/transactions/) and [migrations](https://docs.djangoproject.com/en/6.0/topics/migrations/) for database changes.
- [Management commands](https://docs.djangoproject.com/en/6.0/ref/django-admin/) and [testing](https://docs.djangoproject.com/en/6.0/topics/testing/overview/) for verification.
