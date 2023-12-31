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

// intVariable ::= `i0` | `i1`
// boolVariable ::= `b0` | `b1`
// intExp ::= INTEGER | intExp + intExp | if boolExp intExp intExp |
//            let intVariable : int = intExp in intExp |
//            let boolVariable : bool = boolExp in intExp |
//            intVariable
// boolExp ::= `true` | `false` | boolExp && boolExp |
//             intExp < intExp |
//             if boolExp boolExp boolExp |
//             let intVariable : int = intExp in boolExp |
//             let boolVariable : bool = boolExp in boolExp |
//             boolVariable
// exp ::= intExp | boolExp

// exp ::= INTEGER | VARIABLE |
//         `true` | `false` |
//         exp op exp |
//         `if` exp exp exp |
//         `let` VARIABLE `:` type `=` exp `in` exp

indirect enum Exp {
    case IntegerExp(Int)
    case VariableExp(String)
    case TrueExp
    case FalseExp
    case BinopExp(Exp, Op, Exp)
    case IfExp(Exp, Exp, Exp)
    case LetExp(String, LangType, Exp, Exp)
}

func generateVarName() -> String {
    if Int.random(in: 0..<2) == 0 {
        return "x"
    } else {
        return "y"
    }
}

func generateOp() -> Op {
    switch Int.random(in: 0..<3) {
    case 0: return Op.PlusOp
    case 1: return Op.AndOp
    case _: return Op.LessThanOp
    }
}

func generateType() -> LangType {
    if Int.random(in: 0..<2) == 0 {
        return LangType.IntType
    } else {
        return LangType.BoolType
    }
}

func generateExp() -> Exp {
    switch Int.random(in: 0..<7) {
    case 0: return Exp.IntegerExp(Int.random(in: 0..<100))
    case 1: return Exp.VariableExp(generateVarName())
    case 2: return Exp.TrueExp
    case 3: return Exp.FalseExp
    case 4: return Exp.BinopExp(generateExp(), generateOp(), generateExp())
    case 5: return Exp.IfExp(generateExp(), generateExp(), generateExp())
    case _: return Exp.LetExp(generateVarName(), generateType(), generateExp(), generateExp())
    }
}

enum LangValue {
    case IntValue(Int)
    case BoolValue(Bool)
}

extension Exp {
    func execute() {
        if let _ = self.typecheck([:]) {
            print("\(self): \(self.evaluate([:]))");
        } else {
            print("FAILED TO TYPECHECK: \(self)");
        }
    }
    
    // Variable -> Type
    // String -> Type
    func typecheck(_ env: [String: LangType]) -> LangType? {
        switch self {
        case .IntegerExp(_): return LangType.IntType
        case .VariableExp(let name):
            if let varType = env[name] {
                return varType
            } else {
                return nil
            }
        case .TrueExp: return LangType.BoolType
        case .FalseExp: return LangType.BoolType
        case let .BinopExp(leftExp, op, rightExp):
            if let leftType = leftExp.typecheck(env) {
                if let rightType = rightExp.typecheck(env) {
                    switch (leftType, op, rightType) {
                    case (.IntType, .PlusOp, .IntType): return LangType.IntType
                    case (.BoolType, .AndOp, .BoolType): return LangType.BoolType
                    case (.IntType, .LessThanOp, .IntType): return LangType.BoolType
                    case _: return nil
                    }
                }
            }
            return nil;
        case let .IfExp(guardExp, ifTrue, ifFalse):
            if let guardType = guardExp.typecheck(env) {
                if guardType == LangType.BoolType {
                    if let ifTrueType = ifTrue.typecheck(env) {
                        if let ifFalseType = ifFalse.typecheck(env) {
                            if ifTrueType == ifFalseType {
                                return ifTrueType
                            }
                        }
                    }
                }
            }
            return nil;
        case let .LetExp(varName, expectedVarType, initExp, bodyExp):
            if let actualVarType = initExp.typecheck(env) {
                if actualVarType == expectedVarType {
                    var newEnv = env;
                    newEnv[varName] = expectedVarType;
                    return bodyExp.typecheck(newEnv);
                }
            }
            return nil;
        }
    } // typecheck

    func evaluate(_ env: [String : LangValue]) -> LangValue {
        switch self {
        case .IntegerExp(let value): return LangValue.IntValue(value)
        case .VariableExp(let name): return env[name]!
        case .TrueExp: return LangValue.BoolValue(true)
        case .FalseExp: return LangValue.BoolValue(false)
        case let .BinopExp(leftExp, op, rightExp):
            switch (leftExp.evaluate(env), op, rightExp.evaluate(env)) {
            case let (.IntValue(l), .PlusOp, .IntValue(r)): return LangValue.IntValue(l + r)
            case let (.BoolValue(l), .AndOp, .BoolValue(r)): return LangValue.BoolValue(l && r)
            case let (.IntValue(l), .LessThanOp, .IntValue(r)): return LangValue.BoolValue(l < r)
            case _:
                assert(false);
                return LangValue.IntValue(0);
            }
        case let .IfExp(guardExp, ifTrue, ifFalse):
            if case let LangValue.BoolValue(guardValue) = guardExp.evaluate(env) {
                if guardValue {
                    return ifTrue.evaluate(env)
                } else {
                    return ifFalse.evaluate(env)
                }
            } else {
                assert(false);
                return LangValue.IntValue(0);
            }
        case let .LetExp(varName, _, initialValue, body):
            var newEnv = env
            newEnv[varName] = initialValue.evaluate(env)
            return body.evaluate(newEnv)
        }
    }
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
  Exp.IntegerExp(7));

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

// let x: int = true in x
let illTypedExample = Exp.LetExp(
  "x",
  LangType.IntType,
  Exp.TrueExp,
  Exp.VariableExp("x"));

// 1.) Typechecker of this language
// 2.) Evaluator of this language
// 3.) Fuzzer for this language (automatically generate ASTs)

while true {
    generateExp().execute();
}
