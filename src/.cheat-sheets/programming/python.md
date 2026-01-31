
# Python Cheat Sheet

## Basic Syntax

```python
# Comments start with #
print("Hello, World!")  # Print to console
x = 5  # Variable assignment
if x > 0:
    print("Positive")
elif x < 0:
    print("Negative")
else:
    print("Zero")

# Lists
my_list = [1, 2, 3]
my_list.append(4)  # Add item
my_list.pop()  # Remove last item

# Dictionaries
my_dict = {'key': 'value'}
my_dict['new_key'] = 'new_value'  # Add item

# For loop
for i in range(5):
    print(i)

# While loop
while x > 0:
    x -= 1

# Functions
def greet(name):
    return f"Hello, {name}!"

# Classes
class Dog:
    def __init__(self, name):
        self.name = name
    
    def bark(self):
        return "Woof!"
```

## Data Types

- int: Integer
- float: Floating-point number
- str: String
- bool: Boolean
- list: Ordered, mutable sequence
- tuple: Ordered, immutable sequence
- dict: Key-value pairs
- set: Unordered collection of unique elements

## Common Built-in Functions

- `len()`: Return length of an object
- `type()`: Return type of an object
- `range()`: Generate a sequence of numbers
- `input()`: Read input from user
- `print()`: Print to console
- `sorted()`: Return a new sorted list
- `max()`, `min()`, `sum()`: Mathematical operations on iterables

## File Operations

```python
# Reading a file
with open('file.txt', 'r') as f:
    content = f.read()

# Writing to a file
with open('file.txt', 'w') as f:
    f.write("Hello, World!")
```

## Exception Handling

```python
try:
    # Code that might raise an exception
    result = 10 / 0
except ZeroDivisionError:
    print("Cannot divide by zero!")
finally:
    print("This always executes")
```

## Importing Modules

```python
import math
from datetime import datetime
from collections import Counter, defaultdict
```

## List Comprehensions

```python
squares = [x**2 for x in range(10)]
even_squares = [x**2 for x in range(10) if x % 2 == 0]
```

## Lambda Functions

```python
square = lambda x: x**2
```

## Common Libraries

- NumPy: Numerical computing
- Pandas: Data manipulation and analysis
- Matplotlib: Data visualization
- Scikit-learn: Machine learning
- TensorFlow/PyTorch: Deep learning

## Tips
- Use virtual environments for project isolation
- Follow PEP 8 style guide for code consistency
- Use type hints for better code readability

## Additional Resources
- [Python Official Documentation](https://docs.python.org/3/)
- [Python Package Index (PyPI)](https://pypi.org/)
```
