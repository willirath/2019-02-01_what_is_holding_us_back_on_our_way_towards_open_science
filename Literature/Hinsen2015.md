# Hinsen, Why bitwise reproducibility matters, 2015.

- Distinction Replicability vs. reproducibility
  - **Replicability** aims at "getting the same result from running the same program on the same data"
  - **Reproducibility** aims at "verifying a result with similar but not identical methods and tools"

- Bitwise *replicability* is not unrealistic: "[It]’s a lot of work, but not a technical challenge. We know how to do it, but we are not (yet) willing to invest the effort to make it happen."

- In software testing, testing often means checking against an expected result, "at the bit level".

- "Most scientific programmers are unaware that [floating point arithmetics] is an approximation that they should understand and control. [...] Compiler writers and language specification authors take advantage of this ignorance and declare this step their business, profiting from the many optimization possibilities it offers."

- Gives nice example `a+b+c=(a+b)+c=...` to illustrate why we don't have bitwise replicability.

- No call for bitwise replicability across platforms in *production*, "but it should be possible to reproduce one unique result identically on all platforms".

[Hinsen2015]: https://khinsen.wordpress.com/2015/01/07/why-bitwise-reproducibility-matters/
