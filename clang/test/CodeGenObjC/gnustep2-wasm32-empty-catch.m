// RUN: %clang_cc1 -triple wasm32-unknown-emscripten -fobjc-runtime=gnustep-2.2 -fexceptions -fobjc-exceptions -exception-model=wasm -mllvm -wasm-enable-eh -emit-llvm -o - %s | FileCheck %s
// XFAIL: *
//
// A typed Objective-C catch with no potentially-throwing operation in its try
// body has no EH dispatch block, but the Wasm fallthrough-rethrow path assumes
// one and asserts.

__attribute__((objc_root_class)) @interface Object @end

int emptyCatch(Object *object) {
  @try {
    (void)object;
  } @catch (Object *caught) {
    return caught != (Object *)0;
  }
  return 0;
}

// CHECK-LABEL: define{{.*}} @emptyCatch
