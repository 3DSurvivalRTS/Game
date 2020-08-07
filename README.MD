# RTS SURVIVAL GAME GODOT

## Code Conventions

### Formatting
#### General format
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
#### Comments 
- Comments should be written one statement per line if it is an inline comment. 
- Comments should be on a separate line. 
- Always set a space between the // and the text. Multi-line comments should start from a new line.
```c#
// Like this.
// This is still valid.

// Not like this. This should rather be written 
// as a multi-line comment, because this will
// clutter the code and makes it hard to 
// understand and read through.

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
    // Or do like this.

    // Even if it is for a variable.
    var variable; // This is wrong
}
```
### Naming
- Use PascalCase for class names, enums, interfaces, methods.
- Private class fields should be written using camelCase and can start with an underscore ('_').
- Public and Protected class fields should be written using PascalCase.
- Function parameters and local variables should be written using camelCase.
- Constants must be written in CAPS.
- Enums values can either be written:
    - All in CASE, but with underscores '_'
    - All in PascalCase.
    - One of these two must be consistent within the code base.
```c#
public class Entity : IAbstractEntity
{
    private const int INDEX = 0;
    private GUID _id;
    public GUID Id;
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

    public void DoSomething(int number)
    {
        var someVar = 1;
    }
}
```
### Types
It is preferred to use "var" rather than explicitly indicating a type. 
This way it forces the developer to use descriptive namings for the variables.
There are, however some cases where explicit typing could be used.  
Use *var* wherever you can.  
Consider the following examples:
```c#
    /* 
        These cases should use var, since it is obvious 
        what type the variable is, considering that the 
        naming is descriptive enough.
    */
    var number = 1;
    var numbers = new [] { 1, 2, 3, 4, ... };
    var name = "Godot";
    var enemies = new List<Enemies>();
    var activeStates = GetStates().Where(state => state.IsActive);
    foreach (var entity in entities) { ... }
    // All of these examples are valid applications of var.

    /*
        The following examples are cases where var is 
        used incorrectly, or should not be used at all.
    */

    // The naming of this variable is not descriptive enough.
    // This could cause more trouble than being useful.
    var entityStatus = GetEntityStatus();
    // Is this an enum, or an bool?
    // It could be written like this instead:
    bool entityStatus = GetEntityStatus();
    EntityLifeStatus entityStatus = GetEntityStatus();
    // But if the naming was more descriptive the variable could have looked like this:
    // (respectivly)
    var entityIsAliveStatus = GetEntityStatus()
    var entityLifeStatus = GetEntityStatus();

    // Although this is borderline OK use of a var, it is still not a valid use case.
    // The naming is misleading.
    var number = "1";
```
