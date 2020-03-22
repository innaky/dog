# dog (in-dev)
A funny name inspired in cat of unix-like, this binary apply some file modifications. This executable is an example for using from command line with parametes.

# Usage

## Add 

Append a text in the last line.

```bash
> dog add ~/my_file "Adding this text"
> cat ~/my_file
Adding this text
> dog add ~/my_file "Other text."
Adding this text
Other text.
```

## Num

Return the file with line numbers

```bash
> dog num ~/my_file
0 Adding this text
1 Other text.
```

## Remove

Remove n (number) line of a file.

```bash
> dog remove ~/my_file 0
> cat ~/my_file
Other text.
```

## Cat 

Apply a horizontal fusion file that have a specifically order, util for csv files

```bash
> cat foo
123
123
123
> cat bar
456
456
456
> dog cat foo bar out
> cat out
123 456
123 456
123 456
```
