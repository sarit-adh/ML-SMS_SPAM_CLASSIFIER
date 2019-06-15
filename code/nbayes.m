fid = fopen('SMSSpamCollection');            % read file
data = fread(fid);
fclose(fid);
lcase = abs('a'):abs('z');
ucase = abs('A'):abs('Z');
caseDiff = abs('a') - abs('A');
caps = ismember(data,ucase);
data(caps) = data(caps)+caseDiff;     % convert to lowercase
data(data == 9) = abs(' ');          % convert tabs to spaces
validSet = [9 10 abs(' ') lcase];         
data = data(ismember(data,validSet)); % remove non-space, non-tab, non-(a-z) characters
data = char(data);                    % convert from vector to characters

words = strsplit(data');             % split into words

% split into examples
count = 0;
examples = {};

for (i=1:length(words))
   if (strcmp(words{i}, 'spam') || strcmp(words{i}, 'ham'))
       count = count+1;
       examples(count).spam = strcmp(words{i}, 'spam');
       examples(count).words = [];
   else
       examples(count).words{length(examples(count).words)+1} = words{i};
   end
end

%split into training and test
rng(2,'twister');
random_order = randperm(length(examples));
train_examples = examples(random_order(1:floor(length(examples)*.8)));
test_examples = examples(random_order(floor(length(examples)*.8)+1:end));

%Q 4(a)


alpha = 0.1;

% count occurences for spam and ham
[spamcounts,hamcounts,numspamwords,numhamwords,spam_msg_count,ham_msg_count] =  count_spam_ham(alpha,train_examples);


 
%calculate prior probability

spam_prior = spam_msg_count / (spam_msg_count+ham_msg_count);
ham_prior = ham_msg_count / (spam_msg_count + ham_msg_count);


% Prediction
[actual_label,predicted_label] = predict(spam_prior,ham_prior,spamcounts,hamcounts,numspamwords,numhamwords,test_examples,alpha);

[confusion_matrix, precision,recall,f_score,accuracy] = calculate_performance_measure(actual_label,predicted_label);

fprintf("When , alpha=0.1, Test Set Performance Measure \n")
confusion_matrix
accuracy
precision
recall
f_score




%Q4 (b)


precision_train_list = [];
f_score_train_list = [];
precision_test_list = [];
f_score_test_list = [];

alpha_list =[2^-5, 2^-4 , 2^-3, 2^-2,2^-1,2^0];
for alpha= alpha_list
  
  %performance on train set
  % count occurences for spam and ham
  [spamcounts,hamcounts,numspamwords,numhamwords,spam_msg_count,ham_msg_count] =  count_spam_ham(alpha,train_examples);
 
  %calculate prior probability

  spam_prior = spam_msg_count / (spam_msg_count+ham_msg_count);
  ham_prior = ham_msg_count / (spam_msg_count + ham_msg_count);


  % Prediction
  [actual_label,predicted_label] = predict(spam_prior,ham_prior,spamcounts,hamcounts,numspamwords,numhamwords,train_examples,alpha);

  
  %performance measure
  [confusion_matrix, precision,recall,f_score] = calculate_performance_measure(actual_label,predicted_label);
  
  %update precision and f score list
  precision_train_list = [precision_train_list precision];
  f_score_train_list = [f_score_train_list f_score];
  
  %performance on test set
  
  % Prediction
  [actual_label,predicted_label] = predict(spam_prior,ham_prior,spamcounts,hamcounts,numspamwords,numhamwords,test_examples,alpha);

  
  %performance measure
  [confusion_matrix, precision,recall,f_score] = calculate_performance_measure(actual_label,predicted_label);
  
  %update precision and f score list
  precision_test_list = [precision_test_list precision];
  f_score_test_list = [f_score_test_list f_score];
  
  
end

%plot
  
  subplot(1,2,1) 
  plot(alpha_list,precision_train_list,'o-b',alpha_list,precision_test_list,'o-r');
  xlabel('alpha');
  ylabel('precision');
  title('Plot of precision vs alpha (train set and test set)');
  legend('train set','test set');
  
  subplot(1,2,2)
  plot(alpha_list,f_score_train_list,'o-b',alpha_list,f_score_test_list,'o-r');
  xlabel('alpha');
  ylabel('f score');
  title('Plot of f-score vs alpha (train set and test set)');
  legend('train set','test set');




%spamcounts.get('free')/(numspamwords+alpha*20000)   % probability of word 'free' given spam
%hamcounts.get('free')/(numhamwords+alpha*20000)   % probability of word 'free' given ham
% will need to check if count is empty!

%calculate_probability(spamcounts,'free',numspamwords,alpha)
%calculate_probability(hamcounts,'free',numhamwords,alpha)



% ... 