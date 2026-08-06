// RUN: %clang_cc1 -triple wasm32-unknown-emscripten -fobjc-runtime=gnustep-2.2 -fobjc-arc -fexceptions -fobjc-exceptions -exception-model=wasm -mllvm -wasm-enable-eh -emit-llvm -o - %s | FileCheck %s
// XFAIL: *
//
// Under ARC, a bare Objective-C rethrow leaves a malformed Wasm EH CFG that
// crashes LLVM's verifier/optimizer after CodeGen.

__attribute__((objc_root_class)) @interface Object @end

int arcRethrow(Object *value) {
  @try {
    @throw value;
  } @catch (...) {
    @throw;
  }
  return 0;
}

// CHECK-LABEL: define{{.*}} @arcRethrow
