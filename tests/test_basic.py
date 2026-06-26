import pytest
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.main import app


@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


def test_health(client):
    response = client.get("/health")
    assert response.status_code == 200
    data = response.get_json()
    assert data["status"] == "ok"


def test_calc_endpoint(client):
    response = client.get("/calc?expr=1%2B1")
    assert response.status_code == 200
    data = response.get_json()
    assert data["result"] == 2
