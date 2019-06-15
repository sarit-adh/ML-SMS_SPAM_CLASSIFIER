function [spamcounts,hamcounts,numspamwords,numhamwords,spam_msg_count,ham_msg_count] =  count_spam_ham(alpha,train_examples)

% count occurences for spam and ham

spamcounts = javaObject('java.util.HashMap');
numspamwords = 0;
hamcounts = javaObject('java.util.HashMap');
numhamwords = 0;


spam_msg_count =0;
ham_msg_count =0;

for (i=1:length(train_examples))
    if (train_examples(i).spam == 1) 
      spam_msg_count = spam_msg_count +1;
    else
      ham_msg_count = ham_msg_count+1;
    end
    for (j=1:length(train_examples(i).words))
        word = train_examples(i).words{j};
        if (train_examples(i).spam == 1)
            numspamwords = numspamwords+1;
            current_count = spamcounts.get(word);
            if (isempty(current_count))
                spamcounts.put(word, 1+alpha);    % initialize by including pseudo-count prior
            else
                spamcounts.put(word, current_count+1);  % increment
            end
        else
            numhamwords = numhamwords+1;
            current_count = hamcounts.get(word);
            if (isempty(current_count))
                hamcounts.put(word, 1+alpha);    % initialize by including pseudo-count prior
            else
                hamcounts.put(word, current_count+1);  % increment
            end
        end
        
    end    
end