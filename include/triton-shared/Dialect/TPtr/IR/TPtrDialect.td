#ifndef TPTR_DIALECT
#define TPTR_DIALECT

include "mlir/IR/OpBase.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/Dialect/Ptr/IR/MemorySpaceInterfaces.td"
include "mlir/Dialect/Ptr/IR/PtrDialect.td"
include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/BuiltinAttributeInterfaces.td"
include "mlir/IR/BuiltinTypeInterfaces.td"

def TPtr_Dialect : Dialect {
  let name = "tptr";

  let cppNamespace = "::mlir::tptr";

  let summary = "Temporary Pointer Dialect";

  let description = [{
    Typed Pointer Dialect.
  }];

  let dependentDialects = [
    "mlir::ptr::PtrDialect"
  ];
}

//
// Op Base
//
class TPTR_Op<string mnemonic, list<Trait> traits = []> :
    Op<TPtr_Dialect, mnemonic, traits> {
}

def TPTR_IntToPtrOp : TPTR_Op<"inttoptr", [
    Pure
  ]> {
  let summary = "Integer to a pointer operation";
  let description = [{
    The `inttoptr` operation casts an int or index value to a pointer.

    Example:
    ```mlir
    %ptr = ptr.inttoptr %int : i32 to !ptr.ptr<1 : i32>
    ```
  }];
  let arguments = (ins AnySignlessIntegerOrIndex:$arg);
  let results = (outs Ptr_PtrType:$res);
  let assemblyFormat = "$arg attr-dict `:` type($arg) `to` type($res)";
}

def TPTR_PtrToIntOp : TPTR_Op<"ptrtoint", [
    Pure
  ]> {
  let summary = "Pointer to an integer operation";
  let description = [{
    The `ptrtoint` operation casts a pointer value to an int or index.

    Example:
    ```mlir
    %int = ptr.ptrtoint %ptr : !ptr.ptr<1 : i32> to i32
    ```
  }];
  let arguments = (ins Ptr_PtrType:$arg);
  let results = (outs AnySignlessIntegerOrIndex:$res);
  let assemblyFormat = "$arg attr-dict `:` type($arg) `to` type($res)";
}

def TPTR_FromMemrefOp : TPTR_Op<"from_memref", [Pure]> {
  let arguments = (ins AnyMemRef:$input);
  let results = (outs Ptr_PtrType:$result);
  let assemblyFormat = "$input attr-dict `:` type($input) `to` type($result)";
}

def TPTR_ToMemrefOp : TPTR_Op<"to_memref", [
    Pure  ]> {
  let arguments = (ins Ptr_PtrType:$arg);
  let results = (outs AnyStaticShapeMemRef:$res);
  let assemblyFormat = "$arg attr-dict `:` type($arg) `to` type($res)";
}

def TPTR_PtrAddOp : TPTR_Op<"ptradd", [Pure, AllTypesMatch<["base", "result"]>]> {
  let summary = "Pointer-index add operation";
  let description = [{
    The `ptradd` operation adds an `address` and an integer or index to
    produce a new address.

    Example:
    ```mlir
    %addr = ptr.ptradd %addr : !ptr.ptr<3 : i32>, %c10 : i32
    ```
  }];

  let arguments = (ins Ptr_PtrType:$base, AnySignlessIntegerOrIndex:$offset);
  let results = (outs Ptr_PtrType:$result);
  let assemblyFormat = "$base $offset attr-dict `:` type($base) `,` type($offset) `to` type($result)";
}

#endif // TPTR_DIALECT
