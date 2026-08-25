#include "ad_blocker_c.h"
#include "ad_blocker.h"

extern "C" {

void* ad_blocker_create() {
    return new AdBlocker();
}

void ad_blocker_destroy(void* blocker) {
    delete static_cast<AdBlocker*>(blocker);
}

int ad_blocker_should_block(void* blocker, const char* url) {
    if (!blocker || !url) return 0;
    AdBlocker* instance = static_cast<AdBlocker*>(blocker);
    return instance->ShouldBlock(std::string(url)) ? 1 : 0;
  }
}
