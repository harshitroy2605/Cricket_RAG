"""Central configuration.

Why one settings object?
- Every path, model name and threshold lives in one place (the chess project's config.py
  did the same job, but with hard-coded constants).
- Values come from environment variables / .env, so the same code runs locally,
  in Docker and on Azure without edits. This is the "12-factor app" config rule.
- pydantic validates types at startup, so a typo in .env fails fast instead of mid-request.
"""

from functools import lru_cache
from pathlib import Path

from pydantic import Field, SecretStr
from pydantic_settings import BaseSettings, SettingsConfigDict

PROJECT_ROOT = Path(__file__).resolve().parents[2]


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=PROJECT_ROOT / ".env",
        env_prefix="TU_",  # every variable is TU_<NAME>, so it never clashes with other tools
        extra="ignore",
    )

    # --- environment ---
    env: str = Field("dev", description="dev | test | prod")
    log_level: str = "INFO"

    # --- paths ---
    data_dir: Path = PROJECT_ROOT / "data"

    # --- LLM (Phase 5) ---
    groq_api_key: SecretStr | None = None  # SecretStr keeps the key out of logs and reprs
    llm_model: str = "openai/gpt-oss-120b"

    @property
    def raw_dir(self) -> Path:
        return self.data_dir / "raw"

    @property
    def processed_dir(self) -> Path:
        return self.data_dir / "processed"

    @property
    def rules_dir(self) -> Path:
        return self.data_dir / "rules"


@lru_cache
def get_settings() -> Settings:
    """Cached so the whole app shares one Settings instance (and .env is read once)."""
    return Settings()
