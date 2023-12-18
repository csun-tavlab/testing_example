import random

# op ::= `&&` | `+` | `<`
# exp ::= VARIABLE | INTEGER | `true` | `false` |
#         exp op exp
# type ::= `int` | `bool`
# stmt ::= type VARIABLE `=` exp `;`
# program ::= stmt*


# intExp ::= INTEGER | intExp `+` intExp
# boolExp ::= `true` | `false` |
#              boolExp `&&` boolExp |
#              intExp `<` intExp
# stmt ::= `int` `i` `=` intExp `;` |
#          `bool` `b` `=` boolExp `;`
# program ::= stmt*

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

# intExp ::= INTEGER | intExp `+` intExp
def random_int_exp():
    num = random.randint(0, 1)
    if num == 0:
        return IntegerExp(random.randint(0, 10))
    else:
        return BinopExp(random_int_exp(),
                        PlusOp(),
                        random_int_exp())

# boolExp ::= `true` | `false` |
#              boolExp `&&` boolExp |
#              intExp `<` intExp
def random_bool_exp():
    num = random.randint(0, 3)
    if num == 0:
        return TrueExp()
    elif num == 1:
        return FalseExp()
    elif num == 2:
        return BinopExp(random_bool_exp(),
                        AndOp(),
                        random_bool_exp())
    else:
        return BinopExp(random_int_exp(),
                        LessThanOp(),
                        random_int_exp())

# stmt ::= `int` `i` `=` intExp `;` |
#          `bool` `b` `=` boolExp `;`
def random_stmt():
    num = random.randint(0, 1)
    if num == 0:
        return VardecStmt(IntType(),
                          "i",
                          random_int_exp())
    else:
        return VardecStmt(BoolType(),
                          "b",
                          random_bool_exp())

# program ::= stmt*
def random_program():
    num_stmts = random.randint(0, 10)
    return Program([random_stmt()
                    for _ in range(0, num_stmts + 1)])

print(str(random_program()))
