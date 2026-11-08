from third_umpire.config import Settings, get_settings


def test_defaults_load():
    s = get_settings()
    assert s.llm_model
    assert s.raw_dir.name == "raw"


def test_env_override(monkeypatch):
    monkeypatch.setenv("TU_ENV", "test")
    monkeypatch.setenv("TU_GROQ_API_KEY", "gsk_fake")
    s = Settings()
    assert s.env == "test"
    # the secret is hidden when printed but readable on purpose
    assert "gsk_fake" not in repr(s)
    assert s.groq_api_key.get_secret_value() == "gsk_fake"
