# Bignum
Procedures for long addition and long multiplication of arbitrary-size integers


We chose to represent a bignum with a num list because this would allow us to break down large operations into smaller, more manageable ones involving single digits. We chose to reverse the Arabic numeral format so we could apply operations to the first of the list and recur on the rest of the list in a way that would correspond to mathematical operations on the least to most significant digits in Arabic numerals (first the ones, then the tens, then the hundreds, then the thousands, etc). We decided to maintain the base 10 counting system of Arabic numerals because that's how we are used to counting and carrying.

bignum+ and bignum* each takes two bignums as arguments. First take your two arguments and convert them into bignums. Eg if you want to perform one of these operations on 123 and 456, reverse them and convert them into num lists where each element is a single natural number less than ten: (list 3 2 1) (list 4 5 6). Then add the numbers with (bignum+ (list 3 2 1) (list 4 5 6)) or multiply them with (bignum* (list 3 2 1) (list 4 5 6)).

Overview of bignum+: if the sum of the first digit of bignum1 and bignum2 is less than or equal to 9, just add those two digits, then move on to the next two digits. If the sum is greater than 9, carry the one onto the next digit of bignum1, then move on to adding the next digits. Note that if carrying the one sparks a chain of carrying over a sequence of nines, the helper function carry1 finishes this carrying process, before bignum+ resumes adding the next digits.

Overview of bignum*: For each digit in bignum1, bignum* calls carry-mult to take the partial product of this digit and bignum2. Carry-mult multiplies this digit by each digit in bignum2, and each time it moves to another digit, it conses a zero onto the product to indicate a change in the tens' place. If the product of the two digits is greater than nine, the remainder and quotient procedures split the number into its ones and tens before the bignum+ addition within carry-mult occurs. These partial products are summed with bignum+. This process is repeated for each digit in bignum1 via the sumparprod (sum of partial products) helper procedure. Every time it recurs on bignum1, the partial product of bignum2 and that digit of bignum1 has a 0 consed onto it to indicate a change in the tens' place. These partial products are summed using bignum+. In case one of the inputs was (list 0), which could have produced non-bignum products like (list 0 0 0), extra zeros (two in this case) have to be removed, which is where the dezero helper function comes in.

As far as we know, the program is fully functional and contains no bugs. We recognize something of an incongruity in that some of our procedures (eg carry1, bignum+, carry-mult) contain base cases that check for an empty bignum1 or bignum2. By definition, a bignum cannot be empty, but this does not compromise the program. We treat 0 as any other single-digit bignum, rather than a special case. Also note that our analysis file is kind of overwhelming, but we can explain all of really really clearly and left notes to explain our reasoning.

Collaborators: Tzui Chuang, Rocket Drew, with much love to our TA's <3

No extra features :)
