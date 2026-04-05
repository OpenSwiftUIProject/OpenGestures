// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2015 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//

/*
     File:       OGFTargetConditionals.h

     Contains:   Autoconfiguration of TARGET_ conditionals for Mac OS X and iPhone

                 Note:  OpenSwiftUITargetConditionals.h in 3.4 Universal Interfaces works
                        with all compilers.  This header only recognizes compilers
                        known to run on Mac OS X.

*/

#pragma once

#if __APPLE__
#define OGF_TARGET_OS_DARWIN       1
#define OGF_TARGET_OS_LINUX        0
#define OGF_TARGET_OS_WINDOWS      0
#define OGF_TARGET_OS_BSD          0
#define OGF_TARGET_OS_ANDROID      0
#define OGF_TARGET_OS_CYGWIN       0
#define OGF_TARGET_OS_WASI         0
#elif __ANDROID__
#define OGF_TARGET_OS_DARWIN       0
#define OGF_TARGET_OS_LINUX        1
#define OGF_TARGET_OS_WINDOWS      0
#define OGF_TARGET_OS_BSD          0
#define OGF_TARGET_OS_ANDROID      1
#define OGF_TARGET_OS_CYGWIN       0
#define OGF_TARGET_OS_WASI         0
#elif __linux__
#define OGF_TARGET_OS_DARWIN       0
#define OGF_TARGET_OS_LINUX        1
#define OGF_TARGET_OS_WINDOWS      0
#define OGF_TARGET_OS_BSD          0
#define OGF_TARGET_OS_ANDROID      0
#define OGF_TARGET_OS_CYGWIN       0
#define OGF_TARGET_OS_WASI         0
#elif __CYGWIN__
#define OGF_TARGET_OS_DARWIN       0
#define OGF_TARGET_OS_LINUX        1
#define OGF_TARGET_OS_WINDOWS      0
#define OGF_TARGET_OS_BSD          0
#define OGF_TARGET_OS_ANDROID      0
#define OGF_TARGET_OS_CYGWIN       1
#define OGF_TARGET_OS_WASI         0
#elif _WIN32 || _WIN64
#define OGF_TARGET_OS_DARWIN       0
#define OGF_TARGET_OS_LINUX        0
#define OGF_TARGET_OS_WINDOWS      1
#define OGF_TARGET_OS_BSD          0
#define OGF_TARGET_OS_ANDROID      0
#define OGF_TARGET_OS_CYGWIN       0
#define OGF_TARGET_OS_WASI         0
#elif __unix__
#define OGF_TARGET_OS_DARWIN       0
#define OGF_TARGET_OS_LINUX        0
#define OGF_TARGET_OS_WINDOWS      0
#define OGF_TARGET_OS_BSD          1
#define OGF_TARGET_OS_ANDROID      0
#define OGF_TARGET_OS_CYGWIN       0
#define OGF_TARGET_OS_WASI         0
#elif __wasi__
#define OGF_TARGET_OS_DARWIN       0
#define OGF_TARGET_OS_LINUX        0
#define OGF_TARGET_OS_WINDOWS      0
#define OGF_TARGET_OS_BSD          0
#define OGF_TARGET_OS_ANDROID      0
#define OGF_TARGET_OS_CYGWIN       0
#define OGF_TARGET_OS_WASI         1
#else
#error unknown operating system
#endif

#define OGF_TARGET_OS_WIN32        OGF_TARGET_OS_WINDOWS
#define OGF_TARGET_OS_MAC          OGF_TARGET_OS_DARWIN
#define OGF_TARGET_OS_OSX          OGF_TARGET_OS_DARWIN

// iOS, watchOS, and tvOS are not supported
#define OGF_TARGET_OS_IPHONE        0
#define OGF_TARGET_OS_IOS           0
#define OGF_TARGET_OS_WATCH         0
#define OGF_TARGET_OS_TV            0

#if __x86_64__
#define OGF_TARGET_CPU_PPC          0
#define OGF_TARGET_CPU_PPC64        0
#define OGF_TARGET_CPU_X86          0
#define OGF_TARGET_CPU_X86_64       1
#define OGF_TARGET_CPU_ARM          0
#define OGF_TARGET_CPU_ARM64        0
#define OGF_TARGET_CPU_MIPS         0
#define OGF_TARGET_CPU_MIPS64       0
#define OGF_TARGET_CPU_S390X        0
#define OGF_TARGET_CPU_WASM32       0
#elif __arm64__ || __aarch64__
#define OGF_TARGET_CPU_PPC          0
#define OGF_TARGET_CPU_PPC64        0
#define OGF_TARGET_CPU_X86          0
#define OGF_TARGET_CPU_X86_64       0
#define OGF_TARGET_CPU_ARM          0
#define OGF_TARGET_CPU_ARM64        1
#define OGF_TARGET_CPU_MIPS         0
#define OGF_TARGET_CPU_MIPS64       0
#define OGF_TARGET_CPU_S390X        0
#define OGF_TARGET_CPU_WASM32       0
#elif __mips64__
#define OGF_TARGET_CPU_PPC          0
#define OGF_TARGET_CPU_PPC64        0
#define OGF_TARGET_CPU_X86          0
#define OGF_TARGET_CPU_X86_64       0
#define OGF_TARGET_CPU_ARM          0
#define OGF_TARGET_CPU_ARM64        0
#define OGF_TARGET_CPU_MIPS         0
#define OGF_TARGET_CPU_MIPS64       1
#define OGF_TARGET_CPU_S390X        0
#define OGF_TARGET_CPU_WASM32       0
#elif __powerpc64__
#define OGF_TARGET_CPU_PPC          0
#define OGF_TARGET_CPU_PPC64        1
#define OGF_TARGET_CPU_X86          0
#define OGF_TARGET_CPU_X86_64       0
#define OGF_TARGET_CPU_ARM          0
#define OGF_TARGET_CPU_ARM64        0
#define OGF_TARGET_CPU_MIPS         0
#define OGF_TARGET_CPU_MIPS64       0
#define OGF_TARGET_CPU_S390X        0
#define OGF_TARGET_CPU_WASM32       0
#elif __i386__
#define OGF_TARGET_CPU_PPC          0
#define OGF_TARGET_CPU_PPC64        0
#define OGF_TARGET_CPU_X86          1
#define OGF_TARGET_CPU_X86_64       0
#define OGF_TARGET_CPU_ARM          0
#define OGF_TARGET_CPU_ARM64        0
#define OGF_TARGET_CPU_MIPS         0
#define OGF_TARGET_CPU_MIPS64       0
#define OGF_TARGET_CPU_S390X        0
#define OGF_TARGET_CPU_WASM32       0
#elif __arm__
#define OGF_TARGET_CPU_PPC          0
#define OGF_TARGET_CPU_PPC64        0
#define OGF_TARGET_CPU_X86          0
#define OGF_TARGET_CPU_X86_64       0
#define OGF_TARGET_CPU_ARM          1
#define OGF_TARGET_CPU_ARM64        0
#define OGF_TARGET_CPU_MIPS         0
#define OGF_TARGET_CPU_MIPS64       0
#define OGF_TARGET_CPU_S390X        0
#define OGF_TARGET_CPU_WASM32       0
#elif __mips__
#define OGF_TARGET_CPU_PPC          0
#define OGF_TARGET_CPU_PPC64        0
#define OGF_TARGET_CPU_X86          0
#define OGF_TARGET_CPU_X86_64       0
#define OGF_TARGET_CPU_ARM          0
#define OGF_TARGET_CPU_ARM64        0
#define OGF_TARGET_CPU_MIPS         1
#define OGF_TARGET_CPU_MIPS64       0
#define OGF_TARGET_CPU_S390X        0
#define OGF_TARGET_CPU_WASM32       0
#elif __powerpc__
#define OGF_TARGET_CPU_PPC          1
#define OGF_TARGET_CPU_PPC64        0
#define OGF_TARGET_CPU_X86          0
#define OGF_TARGET_CPU_X86_64       0
#define OGF_TARGET_CPU_ARM          0
#define OGF_TARGET_CPU_ARM64        0
#define OGF_TARGET_CPU_MIPS         0
#define OGF_TARGET_CPU_MIPS64       0
#define OGF_TARGET_CPU_S390X        0
#define OGF_TARGET_CPU_WASM32       0
#elif __s390x__
#define OGF_TARGET_CPU_PPC          0
#define OGF_TARGET_CPU_PPC64        0
#define OGF_TARGET_CPU_X86          0
#define OGF_TARGET_CPU_X86_64       0
#define OGF_TARGET_CPU_ARM          0
#define OGF_TARGET_CPU_ARM64        0
#define OGF_TARGET_CPU_MIPS         0
#define OGF_TARGET_CPU_MIPS64       0
#define OGF_TARGET_CPU_S390X        1
#define OGF_TARGET_CPU_WASM32       0
#elif __wasm32__
#define OGF_TARGET_CPU_PPC          0
#define OGF_TARGET_CPU_PPC64        0
#define OGF_TARGET_CPU_X86          0
#define OGF_TARGET_CPU_X86_64       0
#define OGF_TARGET_CPU_ARM          0
#define OGF_TARGET_CPU_ARM64        0
#define OGF_TARGET_CPU_MIPS         0
#define OGF_TARGET_CPU_MIPS64       0
#define OGF_TARGET_CPU_S390X        0
#define OGF_TARGET_CPU_WASM32       1
#else
#error unknown architecture
#endif

#if __LITTLE_ENDIAN__
#define OGF_TARGET_RT_LITTLE_ENDIAN 1
#define OGF_TARGET_RT_BIG_ENDIAN    0
#elif __BIG_ENDIAN__
#define OGF_TARGET_RT_LITTLE_ENDIAN 0
#define OGF_TARGET_RT_BIG_ENDIAN    1
#else
#error unknown endian
#endif

#if __LP64__ || __LLP64__ || __POINTER_WIDTH__-0 == 64
#define OGF_TARGET_RT_64_BIT        1
#else
#define OGF_TARGET_RT_64_BIT        0
#endif
