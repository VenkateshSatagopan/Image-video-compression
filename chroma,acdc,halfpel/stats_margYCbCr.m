function PMF= stats_margYCbCr(image,min,max)
histogram=hist(image(:),min:max);
PMF=histogram/sum(histogram);
end