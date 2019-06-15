function [confusion_matrix,precision,recall,f_score,accuracy] = calculate_performance_measure(actual_label,predicted_label)
  
  tp = 0;
  fp = 0;
  tn = 0;
  fn = 0;
  
  for i=1:length(actual_label)
    if actual_label(i)==1 && predicted_label(i)==1
      tp = tp+1;
    elseif actual_label(i)==1 && predicted_label(i)==0
      fn = fn+1;
    elseif actual_label(i)==0 && predicted_label(i)==1
      fp = fp+1;
    else
      tn = tn+1;
    end
    
   end  
    
  confusion_matrix = [tp fp;fn tn];
  
  precision = tp / (tp+fp);
  recall = tp / (tp+fn);
  
  f_score = (2 * precision * recall) / (precision+recall);
  accuracy = (tp+tn) / (tp+fp+tn+fn);
  
end