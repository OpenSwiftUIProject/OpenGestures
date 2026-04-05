//
//  OGFVersion.h
//  OpenGestures

#ifndef OGFVersion_h
#define OGFVersion_h

#include <OpenGestures/OGFBase.h>

#define OPENGESTURES_RELEASE 2025

#define OPENGESTURES_RELEASE_2025 2025

#ifndef OPENGESTURES_RELEASE
#define OPENGESTURES_RELEASE OPENGESTURES_RELEASE_2025
#endif

OGF_EXTERN_C_BEGIN

OGF_EXPORT double OpenGesturesVersionNumber;
OGF_EXPORT const unsigned char OpenGesturesVersionString[];

OGF_EXTERN_C_END

#endif /* OGFVersion_h */
