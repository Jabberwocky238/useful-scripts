# dotenv
> [python-dotenv](https://github.com/theskumar/python-dotenv)

## 安装
```bash
pip install python-dotenv
```

## 使用
```python
from dotenv import load_dotenv
import os

load_dotenv()

print(os.getenv('DB_HOST'))
print(os.getenv('DB_PORT'))
```

```python
from dotenv import load_dotenv
import os

load_dotenv("temp_env")

CAO_NI_MA = os.environ.get("CAO_NI_MA")
CAO_NI_MA_BI = os.environ.get("CAO_NI_MA_BI")
PYTHON_HOME = os.environ.get("PYTHON_HOME")

print(CAO_NI_MA)
print(CAO_NI_MA_BI)
print(PYTHON_HOME)
```

## 配置文件
```bash
# .env
DB_HOST=localhost
DB_PORT=3306
```