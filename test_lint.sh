#!/usr/bin/env bash

set -eou pipefail

bazel run \
    --platforms=@bazel_tools//tools:host_platform \
    --host_platform=@bazel_tools//tools:host_platform \
    --extra_execution_platforms=@bazel_tools//tools:host_platform \
    --action_env=BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN= \
    --host_action_env=BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN= \
    --remote_executor= \
    //tools:lint_check
