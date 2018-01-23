cmake_minimum_required (VERSION 3.5)
project (WebRTC_VAD)

SET(INSTALL_DEST "/tmp" CACHE STRING "Some user-specified option")
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_CXX_STANDARD 11)

if(UNIX)
  add_definitions(-DWEBRTC_POSIX)
elseif(WIN32)
  add_definitions(-D_WIN32)
endif()

include_directories(
    ${PROJECT_SOURCE_DIR}
    ${PROJECT_SOURCE_DIR}/rtc_base
    ${PROJECT_SOURCE_DIR}/system_wrappers
    ${PROJECT_SOURCE_DIR}/common_audio/signal_processing
    ${PROJECT_SOURCE_DIR}/common_audio/signal_processing/include
    ${PROJECT_SOURCE_DIR}/common_audio/vad
    ${PROJECT_SOURCE_DIR}/common_audio/vad/include
)

add_library(
  webrtc_vad
  SHARED
   rtc_base/checks.cc
   common_audio/vad/vad_gmm.c
   common_audio/vad/webrtc_vad.c
   common_audio/vad/vad_sp.c
   common_audio/vad/vad_filterbank.c
   common_audio/vad/vad_core.c
   common_audio/vad/vad.cc
   common_audio/signal_processing/ilbc_specific_functions.c
   common_audio/signal_processing/filter_ma_fast_q12.c
   common_audio/signal_processing/downsample_fast.c
   common_audio/signal_processing/dot_product_with_scale.cc
   common_audio/signal_processing/filter_ar_fast_q12.c
   common_audio/signal_processing/resample_by_2.c
   common_audio/signal_processing/resample.c
   common_audio/signal_processing/spl_sqrt_floor.c
   common_audio/signal_processing/auto_corr_to_refl_coef.c
   common_audio/signal_processing/complex_bit_reverse.c
   common_audio/signal_processing/complex_fft.c
   common_audio/signal_processing/min_max_operations.c
   common_audio/signal_processing/filter_ar.c
   common_audio/signal_processing/lpc_to_refl_coef.c
   common_audio/signal_processing/resample_fractional.c
   common_audio/signal_processing/copy_set_operations.c
   common_audio/signal_processing/resample_by_2_mips.c
   common_audio/signal_processing/energy.c
   common_audio/signal_processing/division_operations.c
   common_audio/signal_processing/sqrt_of_one_minus_x_squared.c
   common_audio/signal_processing/auto_correlation.c
   common_audio/signal_processing/vector_scaling_operations.c
   common_audio/signal_processing/randomization_functions.c
   common_audio/signal_processing/splitting_filter.c
   common_audio/signal_processing/levinson_durbin.c
   common_audio/signal_processing/refl_coef_to_lpc.c
   common_audio/signal_processing/get_hanning_window.c
   common_audio/signal_processing/spl_init.c
   common_audio/signal_processing/spl_sqrt.c
   common_audio/signal_processing/resample_by_2_internal.c
   common_audio/signal_processing/resample_48khz.c
   common_audio/signal_processing/real_fft.c
   common_audio/signal_processing/cross_correlation.c
   common_audio/signal_processing/get_scaling_square.c
)

MESSAGE( STATUS "CMAKE_BINARY_DIR:         " ${INSTALL_DEST} )

install(TARGETS webrtc_vad DESTINATION ${INSTALL_DEST})
