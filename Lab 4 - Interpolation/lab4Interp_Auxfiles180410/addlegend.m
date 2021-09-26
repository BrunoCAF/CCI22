% add legend to current figure. 
% use when the figure already has a legend to the existing curves,
% and you want to add a new curve with "hold on".
function addlegend(newstr)
hold on;
l = legend();% get legend object from current figure
l = l.get('String'); % get text property (a cell array of strings)
l{end+1} = newstr; % add new string to the end of cell array
legend(l); % set modified l as the new legend

