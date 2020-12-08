# Coding Style
## Calling Conventions
Unless there are very good reasons to do it otherwise, the standard C m68k calling convention is the way to go:
* ``d0``, ``d1``, ``a0`` and ``a1`` are scratch registers
* All other registers are callee saved / restored
* ``a6`` is the frame pointer
* Parameters are pushed onto the stack, from right to left
* Return value is stored in ``d0``

"Scratch register" means that the caller is aware that the contents are not necessarily the same upon return.
