// RUN: triton-shared-opt --triton-arith-to-linalg="tensor-ptr-to-linalg" --triton-to-ptr --cse --canonicalize %s | FileCheck %s

module {
  tt.func public @cast_with_int_ptr(%arg0: !tt.ptr<i32>, %arg1: !tt.ptr<i32>, %arg2: i32) attributes {noinline = false} {
    %c4_i32 = arith.constant 4 : i32
    %c3_i32 = arith.constant 3 : i32
    %c2_i32 = arith.constant 2 : i32
    %c1_i32 = arith.constant 1 : i32
    %c10_i64 = arith.constant 10 : i64
    %c9_i32 = arith.constant 9 : i32
    %c10_i32 = arith.constant 10 : i32
    %c111_i32 = arith.constant 111 : i32
    %0 = tt.addptr %arg0, %c111_i32 : !tt.ptr<i32>, i32
    %1 = tt.bitcast %0 : !tt.ptr<i32> -> !tt.ptr<i8>
    %2 = tt.addptr %1, %c10_i32 : !tt.ptr<i8>, i32
    %3 = tt.bitcast %2 : !tt.ptr<i8> -> !tt.ptr<i32>
    %4 = tt.ptr_to_int %arg1 : !tt.ptr<i32> -> i64
    %5 = tt.addptr %arg1, %4 : !tt.ptr<i32>, i64
    %6 = tt.addptr %5, %c9_i32 : !tt.ptr<i32>, i32
    %7 = tt.ptr_to_int %6 : !tt.ptr<i32> -> i64
    %8 = arith.remsi %7, %c10_i64 : i64
    %9 = tt.addptr %3, %c1_i32 : !tt.ptr<i32>, i32
    %10 = tt.addptr %9, %8 : !tt.ptr<i32>, i64
    %11 = tt.bitcast %10 : !tt.ptr<i32> -> !tt.ptr<i64>
    %12 = tt.addptr %11, %c2_i32 : !tt.ptr<i64>, i32
    %13 = tt.addptr %12, %arg2 : !tt.ptr<i64>, i32
    %14 = tt.addptr %13, %c3_i32 : !tt.ptr<i64>, i32
    %15 = tt.bitcast %14 : !tt.ptr<i64> -> !tt.ptr<i16>
    %16 = tt.addptr %15, %c4_i32 : !tt.ptr<i16>, i32
    %17 = tt.addptr %16, %arg2 : !tt.ptr<i16>, i32
    %18 = tt.addptr %17, %c3_i32 : !tt.ptr<i16>, i32
    %19 = tt.bitcast %18 : !tt.ptr<i16> -> !tt.ptr<i32>
    %20 = tt.load %19 : !tt.ptr<i32>
    %21 = arith.extsi %arg2 : i32 to i64
    %22 = arith.addi %8, %21 : i64
    %23 = tt.int_to_ptr %22 : i64 -> !tt.ptr<i32>
    tt.store %23, %20 : !tt.ptr<i32>
    tt.return
  }
}

// CHECK-LABEL:  func.func @cast_with_int_ptr
// CHECK-SAME:   ([[PARAM_0_:%.+]]: !tt.ptr<i32>, [[PARAM_1_:%.+]]: !tt.ptr<i32>, [[PARAM_2_:%.+]]: i32, [[PARAM_3_:%.+]]: i32, [[PARAM_4_:%.+]]: i32, [[PARAM_5_:%.+]]: i32, [[PARAM_6_:%.+]]: i32, [[PARAM_7_:%.+]]: i32, [[PARAM_8_:%.+]]: i32) {
// CHECK-DAG:       [[CST_0_:%.+]] = arith.constant 0 : index
// CHECK-DAG:       [[CST_111_:%.+]] = arith.constant 111 : i32
// CHECK-DAG:       [[CST_10_:%.+]] = arith.constant 10 : i32
// CHECK-DAG:       [[CST_9_:%.+]] = arith.constant 9 : i32
// CHECK-DAG:       [[CST_10_1_:%.+]] = arith.constant 10 : i64
// CHECK-DAG:       [[CST_2_:%.+]] = arith.constant 2 : i32
// CHECK-DAG:       [[CST_3_:%.+]] = arith.constant 3 : i32
// CHECK-DAG:       [[CST_4_:%.+]] = arith.constant 4 : i32
// CHECK-DAG:       [[VAR_0_:%.+]] = builtin.unrealized_conversion_cast [[PARAM_1_]] : !tt.ptr<i32> to !ptr.ptr<#ptr.generic_space>
// CHECK-DAG:       [[VAR_1_:%.+]] = builtin.unrealized_conversion_cast [[PARAM_0_]] : !tt.ptr<i32> to !ptr.ptr<#ptr.generic_space>
// CHECK-DAG:       [[VAR_2_:%.+]] = ptr.type_offset i32 : i32
// CHECK:           [[VAR_3_:%.+]] = arith.muli [[VAR_2_]], [[CST_111_]] : i32
// CHECK-DAG:       [[VAR_4_:%.+]] = ptr.ptr_add [[VAR_1_]], [[VAR_3_]] : <#ptr.generic_space>, i32
// CHECK-DAG:       [[VAR_5_:%.+]] = ptr.type_offset i8 : i32
// CHECK:           [[VAR_6_:%.+]] = arith.muli [[VAR_5_]], [[CST_10_]] : i32
// CHECK-DAG:       [[VAR_7_:%.+]] = ptr.ptr_add [[VAR_4_]], [[VAR_6_]] : <#ptr.generic_space>, i32
// CHECK-DAG:       [[VAR_8_:%.+]] = tptr.ptrtoint [[VAR_0_]] : <#ptr.generic_space> to i64
// CHECK-DAG:       [[VAR_9_:%.+]] = ptr.type_offset i32 : i64
// CHECK:           [[VAR_10_:%.+]] = arith.muli [[VAR_8_]], [[VAR_9_]] : i64
// CHECK-DAG:       [[VAR_11_:%.+]] = ptr.ptr_add [[VAR_0_]], [[VAR_10_]] : <#ptr.generic_space>, i64
// CHECK-DAG:       [[VAR_12_:%.+]] = arith.muli [[VAR_2_]], [[CST_9_]] : i32
// CHECK:           [[VAR_13_:%.+]] = ptr.ptr_add [[VAR_11_]], [[VAR_12_]] : <#ptr.generic_space>, i32
// CHECK:           [[VAR_14_:%.+]] = tptr.ptrtoint [[VAR_13_]] : <#ptr.generic_space> to i64
// CHECK-DAG:       [[VAR_15_:%.+]] = arith.remsi [[VAR_14_]], [[CST_10_1_]] : i64
// CHECK-DAG:       [[VAR_16_:%.+]] = ptr.ptr_add [[VAR_7_]], [[VAR_2_]] : <#ptr.generic_space>, i32
// CHECK:           [[VAR_17_:%.+]] = arith.muli [[VAR_15_]], [[VAR_9_]] : i64
// CHECK-DAG:       [[VAR_18_:%.+]] = ptr.ptr_add [[VAR_16_]], [[VAR_17_]] : <#ptr.generic_space>, i64
// CHECK-DAG:       [[VAR_19_:%.+]] = ptr.type_offset i64 : i32
// CHECK:           [[VAR_20_:%.+]] = arith.muli [[VAR_19_]], [[CST_2_]] : i32
// CHECK-DAG:       [[VAR_21_:%.+]] = ptr.ptr_add [[VAR_18_]], [[VAR_20_]] : <#ptr.generic_space>, i32
// CHECK-DAG:       [[VAR_22_:%.+]] = arith.muli [[PARAM_2_]], [[VAR_19_]] : i32
// CHECK-NOT: separator of consecutive DAGs
// CHECK-DAG:       [[VAR_23_:%.+]] = ptr.ptr_add [[VAR_21_]], [[VAR_22_]] : <#ptr.generic_space>, i32
// CHECK-DAG:       [[VAR_24_:%.+]] = arith.muli [[VAR_19_]], [[CST_3_]] : i32
// CHECK-NOT: separator of consecutive DAGs
// CHECK-DAG:       [[VAR_25_:%.+]] = ptr.ptr_add [[VAR_23_]], [[VAR_24_]] : <#ptr.generic_space>, i32
// CHECK-DAG:       [[VAR_26_:%.+]] = ptr.type_offset i16 : i32
// CHECK:           [[VAR_27_:%.+]] = arith.muli [[VAR_26_]], [[CST_4_]] : i32
// CHECK-DAG:       [[VAR_28_:%.+]] = ptr.ptr_add [[VAR_25_]], [[VAR_27_]] : <#ptr.generic_space>, i32
// CHECK-DAG:       [[VAR_29_:%.+]] = arith.muli [[PARAM_2_]], [[VAR_26_]] : i32
// CHECK-NOT: separator of consecutive DAGs
// CHECK-DAG:       [[VAR_30_:%.+]] = ptr.ptr_add [[VAR_28_]], [[VAR_29_]] : <#ptr.generic_space>, i32
// CHECK-DAG:       [[VAR_31_:%.+]] = arith.muli [[VAR_26_]], [[CST_3_]] : i32
// CHECK:           [[VAR_32_:%.+]] = ptr.ptr_add [[VAR_30_]], [[VAR_31_]] : <#ptr.generic_space>, i32
// CHECK:           [[VAR_33_:%.+]] = tptr.to_memref [[VAR_32_]] : <#ptr.generic_space> to memref<1xi32>
// CHECK-DAG:       [[LOAD_VAR_33_MEM_:%.+]] = memref.load [[VAR_33_]]{{.}}[[CST_0_]]{{.}} : memref<1xi32>
// CHECK-DAG:       [[VAR_35_:%.+]] = arith.extsi [[PARAM_2_]] : i32 to i64
// CHECK:           [[VAR_36_:%.+]] = arith.addi [[VAR_15_]], [[VAR_35_]] : i64
// CHECK:           [[VAR_37_:%.+]] = tptr.inttoptr [[VAR_36_]] : i64 to <#ptr.generic_space>
// CHECK:           [[VAR_38_:%.+]] = tptr.to_memref [[VAR_37_]] : <#ptr.generic_space> to memref<1xi32>
// CHECK:           memref.store [[LOAD_VAR_33_MEM_]], [[VAR_38_]]{{.}}[[CST_0_]]{{.}} : memref<1xi32>
// CHECK:           return
// CHECK:         }