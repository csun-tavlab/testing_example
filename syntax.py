import random

# op ::= `&&` | `+` | `<`
# exp ::= VARIABLE | INTEGER | `true` | `false` |
#         exp op exp
# type ::= `int` | `bool`
# stmt ::= type VARIABLE `=` exp `;`
# program ::= stmt*

# int x = 7;
# bool y = x < 10;

# Assume we have a compiler for this language

# &&
class AndOp:
    def __init__(self):
        pass

    def __str__(self):
        return "&&"

# +
class PlusOp:
    def __init__(self):
        pass

    def __str__(self):
        return "+"

# <
class LessThanOp:
    def __init__(self):
        pass

    def __str__(self):
        return "<"

# VARIABLE
class VariableExp:
    def __init__(self, variable_name):
        self.variable_name = variable_name

    def __str__(self):
        return self.variable_name

# INTEGER
class IntegerExp:
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return str(self.value)

# `true`
class TrueExp:
    def __init__(self):
        pass

    def __str__(self):
        return "true"
    
# `false`
class FalseExp:
    def __init__(self):
        pass

    def __str__(self):
        return "false"

# exp op exp
# binary operator
class BinopExp:
    def __init__(self, left, op,  right):
        self.left = left
        self.op = op
        self.right = right

    def __str__(self):
        return "({} {} {})".format(str(self.left),
                                   str(self.op),
                                   str(self.right))

# `int`
class IntType:
    def __init__(self):
        pass

    def __str__(self):
        return "int"

# `bool`
class BoolType:
    def __init__(self):
        pass

    def __str__(self):
        return "bool"
    

# type VARIABLE `=` exp `;`
class VardecStmt:
    def __init__(self, the_type, variable_name, exp):
        self.the_type = the_type
        self.variable_name = variable_name
        self.exp = exp

    def __str__(self):
        return "{} {} = {};".format(str(self.the_type),
                                    self.variable_name,
                                    str(self.exp))
    

# program ::= stmt*
class Program:
    def __init__(self, stmts):
        self.stmts = stmts

    def __str__(self):
        return "\n".join([str(stmt)
                          for stmt in self.stmts])
    
# op ::= `&&` | `+` | `<`
def random_op():
    num = random.randint(0, 2)
    if num == 0:
        return AndOp()
    elif num == 1:
        return PlusOp()
    else:
        return LessThanOp()

# type ::= `int` | `bool`
def random_type():
    num = random.randint(0, 1)
    if num == 0:
        return IntType()
    else:
        return BoolType()

def random_variable_name():
    num = random.randint(0, 10)
    return "x{}".format(num)

# exp ::= VARIABLE | INTEGER | `true` | `false` |
#         exp op exp
def random_exp(bound):
    if bound <= 0:
        # only allow base cases
        num = random.randint(0, 3)
    else:
        bound = bound - 1
        num = random.randint(0, 4)
        
    if num == 0:
        return VariableExp(random_variable_name())
    elif num == 1:
        return IntegerExp(random.randint(0, 10))
    elif num == 2:
        return TrueExp()
    elif num == 3:
        return FalseExp()
    else:
        return BinopExp(random_exp(bound),
                        random_op(),
                        random_exp(bound))

# stmt ::= type VARIABLE `=` exp `;`
def random_stmt(bound):
    return VardecStmt(random_type(),
                      random_variable_name(),
                      random_exp(bound))

# program ::= stmt*
def random_program(bound):
    num_stmts = random.randint(0, 10)
    return Program([random_stmt(bound)
                    for _ in range(0, num_stmts + 1)])

# int x = 7;
# bool y = x < 10;
#
# abstract syntax tree
# program = Program([VardecStmt(IntType(),
#                               "x",
#                               IntegerExp(7)),
#                    VardecStmt(BoolType(),
#                               "y",
#                               BinopExp(VariableExp("x"),
#                                        LessThanOp(),
#                                        IntegerExp(10)))])
# print(str(program))

# max depth of any expression: 2
print(str(random_program(2)))
