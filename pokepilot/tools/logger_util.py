"""统一的日志配置工具"""

import logging

# 创建模块级别的 logger
logger = logging.getLogger(__name__)


def setup_logger(name: str = None, debug: bool = False) -> logging.Logger:
    """配置并返回日志对象

    Args:
        name: logger 名称，默认为调用模块的 __name__
        debug: 是否启用 DEBUG 级别

    Returns:
        配置好的 logger 对象
    """
    if name is None:
        name = __name__

    logger_obj = logging.getLogger(name)
    level = logging.DEBUG if debug else logging.INFO

    # 避免重复添加 handler
    if not logger_obj.handlers:
        handler = logging.StreamHandler()
        formatter = logging.Formatter(
            '%(levelname)-8s | %(message)s'
        )
        handler.setFormatter(formatter)
        logger_obj.addHandler(handler)

    logger_obj.setLevel(level)
    return logger_obj
