require "apis/log"

log.level = "info"
log.file = "logtest.log"
log.stdout = false

log.trace("aaaa")
log.debug("bbbb")
log.info("cccc")
log.warn("dddd")
log.error("eeee")
log.fatal("ffff")


