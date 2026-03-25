# Python Stack Notes

> Reference notes for Python projects. Covers general patterns, common libraries,
> and gotchas relevant to Cody's projects (scraping, AI/ML, automation, APIs).

---

## Project Setup

```bash
python3 -m venv venv
source venv/bin/activate        # macOS/Linux
venv\Scripts\activate           # Windows
pip install -r requirements.txt
```

### Recommended folder structure

```
/project-name
  /src
    /utils      ← helper functions
    /models     ← data models or ML models
    main.py     ← entry point
  /tests
  requirements.txt
  .env
  README.md
```

---

## Environment Variables

```python
from dotenv import load_dotenv
import os

load_dotenv()
API_KEY = os.getenv('API_KEY')
```

Always use `python-dotenv` — never hardcode secrets.

---

## Common Patterns

### Async with aiohttp

```python
import aiohttp
import asyncio

async def fetch(url):
  async with aiohttp.ClientSession() as session:
    async with session.get(url) as response:
      return await response.json()

asyncio.run(fetch('https://api.example.com'))
```

### Web scraping with BeautifulSoup

```python
import requests
from bs4 import BeautifulSoup

def scrape(url):
  response = requests.get(url, headers={'User-Agent': 'Mozilla/5.0'})
  soup = BeautifulSoup(response.text, 'html.parser')
  return soup.select('.target-class')
```

### FastAPI endpoint

```python
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class Item(BaseModel):
  name: str
  value: float

@app.get('/items/{item_id}')
async def get_item(item_id: int):
  return {'id': item_id}

@app.post('/items')
async def create_item(item: Item):
  return item
```

### File I/O

```python
# Always use context managers
with open('file.txt', 'r') as f:
  content = f.read()

# JSON
import json
with open('data.json', 'w') as f:
  json.dump(data, f, indent=2)
```

---

## Libraries Cody Uses

| Library                | Purpose            |
| ---------------------- | ------------------ |
| `requests`             | HTTP requests      |
| `aiohttp`              | Async HTTP         |
| `beautifulsoup4`       | HTML scraping      |
| `playwright`           | Browser automation |
| `fastapi`              | API framework      |
| `pydantic`             | Data validation    |
| `python-dotenv`        | Env var management |
| `pytest`               | Testing            |
| `openai` / `anthropic` | AI API clients     |

---

## Gotchas

- Always activate venv before running — forgetting causes confusing import errors
- `pip install` without venv pollutes global Python — always use venv or pipx
- `requests` is sync — use `aiohttp` or `httpx` for async scraping
- BeautifulSoup needs a parser specified — use `html.parser` (built-in) or `lxml` (faster, needs install)
- Playwright needs browsers installed separately: `playwright install chromium`
- On macOS, `python` may point to Python 2 — always use `python3` explicitly
- WSL: file paths use Linux conventions — `/mnt/c/` not `C:\`
