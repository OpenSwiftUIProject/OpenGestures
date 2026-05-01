//
//  interpose.c
//  OpenGestures

#include <OpenGestures/OGFBase.h>
#include <stdbool.h>
#include <string.h>

#if OGF_TARGET_OS_DARWIN
extern bool os_variant_has_internal_diagnostics(const char *subsystem);
#endif

bool ogf_variant_has_internal_diagnostics(const char *subsystem) {
    if (strcmp(subsystem, "org.OpenSwiftUIProject.OpenGestures") == 0) {
        return true;
    } else if (strcmp(subsystem, "com.apple.Gestures") == 0) {
        return true;
    } else {
        #if OGF_TARGET_OS_DARWIN
        return os_variant_has_internal_diagnostics(subsystem);
        #else
        return false;
        #endif
    }
}

#if OGF_TARGET_OS_DARWIN
#define DYLD_INTERPOSE(_replacement,_replacee) \
    __attribute__((used)) static struct{ const void* replacement; const void* replacee; } _interpose_##_replacee \
    __attribute__ ((section ("__DATA,__interpose"))) = { (const void*)(unsigned long)&_replacement, (const void*)(unsigned long)&_replacee };

DYLD_INTERPOSE(ogf_variant_has_internal_diagnostics, os_variant_has_internal_diagnostics)
#endif
