from dotenv import load_dotenv
import os

load_dotenv("temp_env")

CAO_NI_MA = os.environ.get("CAO_NI_MA")
CAO_NI_MA_BI = os.environ.get("CAO_NI_MA_BI")
PYTHON_HOME = os.environ.get("PYTHON_HOME")

print(CAO_NI_MA)
print(CAO_NI_MA_BI)
print(PYTHON_HOME)
