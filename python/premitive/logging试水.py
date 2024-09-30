import logging

# 配置日志记录
logging.basicConfig(level=logging.DEBUG, 
                    format='[%(asctime)s] - %(levelname)s : %(message)s',
                    # filename='logging试水.log',
                    # filemode='w'
                    )
# 获取日志记录器
logger = logging.getLogger(__name__)
print(logger)
logger.debug("logger debug")
logging.debug("debug")
logging.info("info")
logging.warning("warning")
logging.error("error")
logging.critical("critical")