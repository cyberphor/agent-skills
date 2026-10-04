# Python Code Examples

Use these examples as generic references for the style. They intentionally avoid project-specific names, identifiers, endpoints, and domain details.

## Small Module with Configuration

```python
# Standard library imports.
from os import environ
from pathlib import Path

# Constants.
DEFAULT_OUTPUT_DIRECTORY = Path("output")


def get_output_directory() -> Path:
    """Get the configured output directory."""
    return Path(environ.get("OUTPUT_DIRECTORY", DEFAULT_OUTPUT_DIRECTORY))
```

Use module-level constants for stable defaults. Keep configuration conversion explicit.

## Required Startup Configuration

```python
# Standard library imports.
from os import environ


def get_port() -> int:
    """Get the service port.

    Returns:
        The configured service port.

    Raises:
        RuntimeError: If the service port is not configured.
        ValueError: If the configured value is not an integer.
    """
    if "SERVICE_PORT" not in environ:
        raise RuntimeError("The SERVICE_PORT environment variable is not set.")

    return int(environ["SERVICE_PORT"])
```

Validate required startup values at the boundary instead of allowing a later, less obvious failure.

## Explicit Provider Dispatch

```python
class ClientError(Exception):
    """Raised when a client cannot be created."""


def get_client(provider: str):
    """Create a client for the requested provider."""
    match provider:
        case "provider_a":
            return get_provider_a_client()
        case "provider_b":
            return get_provider_b_client()
        case _:
            raise ClientError(
                "Invalid provider. Expected one of: provider_a, provider_b."
            )
```

Use explicit dispatch when supported modes are few and well defined.

## Domain Parser

```python
# Standard library imports.
from pathlib import Path
from typing import TypedDict

# Third party imports.
from defusedxml import ElementTree


class Record(TypedDict):
    identifier: str
    title: str


class RecordParseError(Exception):
    """Raised when a record file cannot be parsed."""


def read_records(path: str) -> list[Record]:
    """Read records from an XML file.

    Args:
        path: Path to the XML file.

    Returns:
        Records extracted from the document.

    Raises:
        RecordParseError: If the file is missing or malformed.
    """
    input_path = Path(path)

    if not input_path.is_file():
        raise RecordParseError(f"No such file: {path}")

    try:
        tree = ElementTree.parse(input_path)
    except ElementTree.ParseError as exc:
        raise RecordParseError(f"Malformed XML in {path}: {exc}") from exc

    records = [
        {
            "identifier": element.get("id", ""),
            "title": element.findtext("title", default="").strip(),
        }
        for element in tree.findall(".//record")
    ]

    if not records:
        raise RecordParseError(f"No records found in {path}.")

    return records
```

Use domain-specific exceptions when callers need to distinguish parsing failures from unrelated errors.

## Async HTTP Integration

```python
# Third party imports.
from httpx import AsyncClient


async def get_coordinates(location: str) -> dict[str, float]:
    """Get coordinates for a location.

    Args:
        location: Human-readable location.

    Returns:
        Latitude and longitude values.
    """
    async with AsyncClient(timeout=10.0) as client:
        response = await client.get(
            "https://api.example.test/coordinates",
            params={"q": location},
        )
        response.raise_for_status()
        data = response.json()

    return {
        "latitude": float(data["latitude"]),
        "longitude": float(data["longitude"]),
    }
```

Keep request construction explicit, check the response status, and return a structured result.

## FastMCP Service Entrypoint

```python
# Standard library imports.
from os import environ
from pathlib import Path

# Third party imports.
from fastmcp import FastMCP
from fastmcp.server.providers.skills import SkillsDirectoryProvider
from starlette.requests import Request
from starlette.responses import JSONResponse


def main() -> None:
    """Start the MCP server."""
    if "FASTMCP_PORT" not in environ:
        raise RuntimeError("The FASTMCP_PORT environment variable is not set.")

    fastmcp_port = int(environ["FASTMCP_PORT"])

    # Init an MCP server.
    mcp = FastMCP(name="example")

    # Register skills with the MCP server.
    mcp.add_provider(
        SkillsDirectoryProvider(
            roots=Path(__file__).parent / "skills",
        )
    )

    @mcp.custom_route("/api/v1/health", methods=["GET"])
    async def health(request: Request) -> JSONResponse:
        """Respond to health checks.

        Returns:
            A JSON response that indicates the service is running.
        """
        return JSONResponse(content={"status": "ok"})

    # Start the MCP server.
    mcp.run(
        transport="streamable-http",
        host="0.0.0.0",
        port=fastmcp_port,
    )


if __name__ == "__main__":
    main()
```

Keep service startup linear and visible.

## FastAPI Lifespan Orchestration

```python
# Standard library imports.
from contextlib import asynccontextmanager

# Third party imports.
from fastapi import FastAPI


api = FastAPI()


@asynccontextmanager
async def lifespan(app: FastAPI):
    client = await create_client()
    register_routes(app=app, client=client)
    yield
    await client.aclose()


api.router.lifespan_context = lifespan
```

Use lifespan boundaries for resources that should be constructed and cleaned up with the application.

## Django Ninja Router

```python
# Third party imports.
from ninja import Router

# Local imports.
from records.models import Record
from records.schemas import NotFoundSchema, RecordSchema


record_router = Router(tags=["records"])


@record_router.get("/{record_id}", response={200: RecordSchema, 404: NotFoundSchema})
def get_record(request, record_id: int):
    try:
        return 200, Record.objects.get(id=record_id)
    except Record.DoesNotExist:
        return 404, {"message": "record not found"}
```

Use the framework's response conventions and keep endpoint behavior narrow.

## Focused Transformation

```python
def normalize_names(values: list[str]) -> list[str]:
    """Normalize and sort non-empty names."""
    return sorted(
        value.strip()
        for value in values
        if value.strip()
    )
```

A short comprehension is appropriate when the transformation remains obvious.

## Explicit Loop for Branching Logic

```python
def validate_records(records: list[dict[str, str]]) -> list[str]:
    """Return validation errors for the provided records."""
    errors: list[str] = []

    for index, record in enumerate(records):
        if not record.get("name"):
            errors.append(f"Record {index} is missing a name.")
            continue

        if not record.get("value"):
            errors.append(f"Record '{record['name']}' is missing a value.")

    return errors
```

Prefer an explicit loop once branching would make a comprehension difficult to scan.

## Pytest Example

```python
# Third party imports.
import pytest

# Local imports.
from example.parser import RecordParseError, read_records


def test_read_records_rejects_missing_file(tmp_path) -> None:
    missing_path = tmp_path / "missing.xml"

    with pytest.raises(RecordParseError, match="No such file"):
        read_records(str(missing_path))
```

Test the public contract and expected failure mode rather than internal implementation details.

## Avoid Unnecessary Abstraction

Prefer:

```python
def build_message(name: str) -> str:
    return f"Hello, {name}."
```

Over introducing a class, factory, interface, or dependency injection layer when there is only one behavior and no current requirement for extension.

## Comments

Prefer:

```python
# Load the policy once so every registered tool uses the same rules.
policy = get_policy()
```

Avoid:

```python
# Get the policy.
policy = get_policy()
```

Comments should explain intent, lifecycle, or a non-obvious constraint.
