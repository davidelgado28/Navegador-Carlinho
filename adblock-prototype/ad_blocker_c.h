#ifndef AD_BLOCKER_C_H
#define AD_BLOCKER_C_H

#ifdef __cplusplus
extern "C" {
#endif

    void* ad_blocker_create();
    void ad_blocker_destroy(void* blocker);
    int ad_blocker_should_block(void* blocker, const char* url);

#ifdef __cplusplus
}
#endif

#endif
