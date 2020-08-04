# RTS SURVIVAL GAME GODOT

## Code Conventions

### General Code Conventions
Curly brackets are to be set one line after the statement declaration:
```c#
void Function(int number)
{
    if (number == 0)
    {
        // Do something.
    }
}
```
Comments should be written one statement per line if it is an inline comment. Comments should be on a separate line. Always set a space between the // and the text. Multi-line comments should start from a new line.
```c#
// Like this.

// Not like this. This should rather be written as a multi-line comment, because this will
// clutter the code and makes it hard to understand and read through.

/*
    Like this. Because now you can write as much as you want.
    This easier to read than a single inline comment.
*/

/*Dont' write multi-line comments like this*/

/*  or
    like
    this */

// Do write comments like this.

void Function() // Don't write comments like this
{
    // Or like this.

    // Event if it is for a variable.
    var variable; // This is wrong
}

```
### Naming Conventions
Use PascalCase for class names, enums, interfaces, methods.
Constants must be written in CAPS.
Enums values can either be written:
- All in CASE, but with underscores '_'
- All in PascalCase. 
One of these two must be consistent within the code base.
```c#
public class Entity : IAbstractEntity
{
    private const int INDEX = 0;
    public enum EntityStates
    {
        Alive,
        TryingToRun,
        Dead,

        // OR

        ALIVE,
        TRYING_TO_RUN,
        DEAD
    }

    public void DoSomething()
    {

    }
}
```
Use camelCase for variable names
