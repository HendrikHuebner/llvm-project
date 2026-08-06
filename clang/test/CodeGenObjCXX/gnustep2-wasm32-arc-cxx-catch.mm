// RUN: %clang_cc1 -triple wasm32-unknown-emscripten -fobjc-runtime=gnustep-2.2 -fobjc-arc -fexceptions -fobjc-exceptions -fcxx-exceptions -exception-model=wasm -mllvm -wasm-enable-eh -emit-llvm -o - %s | FileCheck %s
// XFAIL: *
//
// An ARC object cleanup reached from an outer C++ catch is emitted in a block
// shared with a Wasm funclet, but llvm.objc.storeStrong has no funclet bundle.

__attribute__((objc_root_class)) @interface Object @end
extern void mayThrowCXX();

int arcObjectAcrossCxxCatch(Object *object) {
  try {
    Object *local = object;
    mayThrowCXX();
    (void)local;
  } catch (...) {
    return object != (Object *)0;
  }
  return 0;
}

// CHECK-LABEL: define{{.*}} @arcObjectAcrossCxxCatch
