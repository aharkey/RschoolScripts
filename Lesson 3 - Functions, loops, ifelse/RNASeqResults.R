# Given a range of values, which value has the largest absolute value
maxabs <- function(a)
{ifelse(max(a)>abs(min(a)), max(a), min(a))}

# Given a logFC and pvalue, and cutoffs for both, return a single character
# representing the direction of change (U or D) or no change (n)
upordown <- function(pval, lfc, pcut = 0.05, lfccut = 0.5)
{if(pval < pcut & abs(lfc) > lfccut)
{if(lfc > 0)
{out <- "U"}
  else
  {out <- "D"}}
  else
  {out <- "n"}
  return(out)}
