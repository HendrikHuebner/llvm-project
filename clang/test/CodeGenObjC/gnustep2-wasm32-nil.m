// RUN: %clang_cc1 -triple wasm32-unknown-emscripten -emit-llvm -fobjc-runtime=gnustep-2.2 -o - %s | FileCheck %s

@interface Object
- (int)value;
@end

int sendToPossiblyNil(Object *object) {
  // CHECK-LABEL: define{{.*}} i32 @sendToPossiblyNil
  // CHECK: icmp eq ptr %{{.*}}, null
  // CHECK: br i1 %{{.*}}, label %[[CONTINUE:.*]], label %[[SEND:.*]]
  // CHECK: [[SEND]]:
  // CHECK: call ptr @objc_msg_lookup_sender
  // CHECK: br label %[[CONTINUE]]
  // CHECK: [[CONTINUE]]:
  // CHECK: phi i32 [ %{{.*}}, %[[SEND]] ], [ 0, %{{.*}} ]
  return [object value];
}
