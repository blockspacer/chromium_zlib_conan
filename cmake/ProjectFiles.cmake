include_guard( DIRECTORY )

# if (current_cpu == "x86" || current_cpu == "x64")
if(TARGET_LINUX) # TODO
  #list(APPEND zlib_SOURCES
  #  ${GZLIB_DIR}intel/filter_sse2_intrinsics.c
  #  ${GZLIB_DIR}intel/intel_init.c
  #)
  #set(PNG_INTEL_SSE_OPT_DEFINE PNG_INTEL_SSE_OPT=1)
  #find_package(ZLIB)
endif()

if(TARGET_LINUX OR TARGET_WINDOWS)
  list(APPEND zlib_SOURCES
    # TODO: https://github.com/chromium/chromium/blob/18f14dd8fb096b0b895832a7dbaec02383bdc343/third_party/zlib/BUILD.gn
    simd_stub.c
  )
elseif(TARGET_EMSCRIPTEN)
  # skip
else()
  message(FATAL_ERROR "unknown platform")
endif()

list(APPEND zlib_SOURCES
  adler32.c
  compress.c
  crc32.c
  deflate.c
  gzclose.c
  gzlib.c
  gzread.c
  gzwrite.c
  infback.c
  inffast.c
  inftrees.c
  trees.c
  uncompr.c
  zutil.c
)

if (use_arm_neon_optimizations)
  list(APPEND zlib_SOURCES
    adler32_simd.c
  )
endif()

if (use_x86_x64_optimizations) 
  list(APPEND zlib_SOURCES
    adler32_simd.c
  )
endif()

if (use_arm_neon_optimizations)
  if (IS_CLANG AND NOT IS_IOS)
    list(APPEND zlib_SOURCES
      "arm_features.c"
      "arm_features.h"
      "crc32_simd.c"
      "crc32_simd.h"
    )
  endif()
endif()

if (use_x86_x64_optimizations OR use_arm_neon_optimizations)
  list(APPEND zlib_SOURCES
    "contrib/optimizations/chunkcopy.h"
    "contrib/optimizations/inffast_chunk.c"
    "contrib/optimizations/inffast_chunk.h"
    "contrib/optimizations/inflate.c"
  )
endif()

if (use_x86_x64_optimizations)
  list(APPEND zlib_SOURCES
    "crc32_simd.c"
    "crc32_simd.h"
  )
endif()

if (use_x86_x64_optimizations)
  list(APPEND zlib_SOURCES
    "crc_folding.c"
    "fill_window_sse.c"
  )
else()
  list(APPEND zlib_SOURCES
    "simd_stub.c"
  )
endif()

if (use_x86_x64_optimizations OR use_arm_neon_optimizations)
  if (use_x86_x64_optimizations)
    list(APPEND zlib_SOURCES
      "x86.c"
    )
  elseif (use_arm_neon_optimizations)
    list(APPEND zlib_SOURCES
      "contrib/optimizations/slide_hash_neon.h"
    )
  endif()
else()
  list(APPEND zlib_SOURCES
    "inflate.c"
  )
endif()

list(TRANSFORM zlib_SOURCES PREPEND "${zlib_DIR}")
