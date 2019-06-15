function prob = calculate_likelihood(words_map, word, words_count,alpha)
  prob = (words_map.get(word)+alpha)/(words_count+alpha*20000);
  
  %if word is not in map, [] is returned which should be taken care of
  
  if isempty(prob)
     prob = alpha/(words_count+alpha*20000);
  end

end