// type ::= `int` | `bool`
enum LangType {
    case IntType
    case BoolType
}

// op ::= `+` | `&&` | `<`
enum Op {
    case PlusOp
    case AndOp
    case LessThanOp
}

// exp ::= INTEGER | VARIABLE |
//         exp op exp |
//         `if` exp exp exp |
//         `let` VARIABLE `:` type `=` exp `in` exp
indirect enum Exp {
    case IntegerExp(Int)
    case VariableExp(String)
    case BinopExp(Exp, Op, Exp)
    case IfExp(Exp, Exp, Exp)
    case LetExp(String, LangType, Exp, Exp)
}

// 3 + 2
let add = Exp.BinopExp(
  Exp.IntegerExp(3),
  Op.PlusOp,
  Exp.IntegerExp(2));

// if (2 < 3) 5 else 7
let ifExample = Exp.IfExp(
  Exp.BinopExp(
    Exp.IntegerExp(2),
    Op.LessThanOp,
    Exp.IntegerExp(3)),
  Exp.IntegerExp(5),
  Exp.IntegerExp(7))

// let x: int = 7 in
// x + 5
let letExample = Exp.LetExp(
  "x",
  LangType.IntType,
  Exp.IntegerExp(7),
  Exp.BinopExp(
    Exp.VariableExp("x"),
    Op.PlusOp,
    Exp.IntegerExp(5)));


// 1.) Typechecker of this language
// 2.) Evaluator of this language
// 3.) Fuzzer for this language (automatically generate ASTs)

