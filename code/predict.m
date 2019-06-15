function [actual_label,predicted_label] = predict(spam_prior,ham_prior,spamcounts,hamcounts,numspamwords,numhamwords,examples,alpha)

% training set performance measure
actual_label = [];
predicted_label = [];
for i =1:length(examples)
  actual_label(i) = examples(i).spam;
  
  product_likelihood_spam = 1;
  product_likelihood_ham = 1;
  for j=1:length(examples(i).words)
    current_word = char(examples(i).words(j));
    product_likelihood_spam = product_likelihood_spam * calculate_likelihood(spamcounts,current_word,numspamwords,alpha);
    product_likelihood_ham = product_likelihood_ham * calculate_likelihood(hamcounts,current_word,numhamwords,alpha);   
  end
  
  %calculating proportional posterior probability , 
  %not actual posterior probability , not divided by probability of word
  posterior_prob_spam =  spam_prior * product_likelihood_spam;
  posterior_prob_ham = ham_prior * product_likelihood_ham;
  
  if posterior_prob_spam > posterior_prob_ham
    predicted_label(i) = 1; %spam
  else
    predicted_label(i) = 0; %not spam
  end
  
end
end