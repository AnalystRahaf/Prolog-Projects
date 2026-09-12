% CEAI 281 - AI Tools Recommendation System

% ==================== FACTS ====================

% Facts: task types
task(text).
task(images).
task(coding).
task(ml).

% Facts: skill levels
level(beginner).
level(intermediate).
level(advanced).

% Facts: budget types
budget(free). 
budget(freemium). 
budget(paid). 

% Text-related tasks
ai_tool('ChatGPT', text, beginner, freemium).
ai_tool('Claude', text, advanced, freemium).
ai_tool('Google Gemini', text, intermediate, free).
ai_tool('Copy.ai', text, beginner, paid).
ai_tool('Jasper', text, intermediate, paid).

% Image generation tasks
ai_tool('Midjourney', images, advanced, paid).
ai_tool('DALL-E', images, beginner, freemium).
ai_tool('Stable Diffusion', images, intermediate, free).
ai_tool('Adobe Firefly', images, intermediate, paid).
ai_tool('Canva AI', images, beginner, freemium).

% Coding assistance tasks
ai_tool('GitHub Copilot', coding, beginner, paid).
ai_tool('Codeium', coding, intermediate, free).
ai_tool('Tabnine', coding, advanced, freemium).
ai_tool('Amazon CodeWhisperer', coding, beginner, free).
ai_tool('Replit Chostwriter', coding, intermediate, freemium).

% Data science / ML tasks
ai_tool('HuggingFace Models', ml, advanced, free).
ai_tool('Azure AI Services', ml, intermediate, paid).
ai_tool('Google Cloud AI', ml, advanced, paid).
ai_tool('TensorFlow', ml, intermediate, free).
ai_tool('Scikit-learn', ml, beginner, free).
ai_tool('DataRobot', ml, advanced, paid).


% ==================== RULES ====================

% Rule 1: Suggestion rule (task + level + budget)
suggest(Tool) :-
    write('What is your task type?: '), read(Task),
    write('What is your skill level?: '), read(Level),
    write('What is your budget? (free/freemium/paid): '), read(Budget),
    
    (   ai_tool(Tool, Task, Level, Budget)
    ->   write('Recommended tool: '), write(Tool), nl
    ;    write('No tools match your criteria'), nl
    ).

% Rule 2: find all tools match (task + level + budget)
find_by_criteria :- 
    write('Enter task: '), read(Task),
    write('Enter your skill level: '), read(Level),
    write('Enter budget: '), read(Budget),
    
    findall(Tool, ai_tool(Tool, Task, Level, Budget), Tools),
    (    Tools \= []
    ->   write('Matching tool(s): '), write(Tools), nl
    ;   write('No tools match your criteria'), nl
    ).

% Rule 3: Show free tools for a task
show_free_tools :-
    write('Enter task type: '), read(Task),
    write('FREE TOOLS for '), write(Task), write(': '), nl,
    forall(ai_tool(Tool, Task, _, free), 
           (write('- '), write(Tool), nl)).

% Rule 4: AI tool recommendation with alternative suggestions
best_match :- 
    write('=== AI TOOL RECOMMENDER ==='), nl,
    write('Task: '), read(Task),
    write('Level: '), read(Level),
    write('Budget (free/freemium/paid): '), read(Budget),
    
    (   findall(Tool, ai_tool(Tool, Task, Level, Budget), ExactMatches),
        ExactMatches \= []
    ->  write('Perfect match: '), write(ExactMatches), nl
    ;   write('No exact match. Trying alternatives...'), nl,
        findall(Tool, ai_tool(Tool, Task, Level, _), SameTaskLevel),
        (   SameTaskLevel \= []
        ->  write('Tools for '), write(Task), write(' at '), write(Level), write(' level: '), 
            write(SameTaskLevel), nl
        ;   findall(Tool, ai_tool(Tool, Task, _, _), SameTask),
            write('Tools for '), write(Task), write(': '), write(SameTask), nl
        )
    ). 

% Rule 5: Budget comparison
compare_by_budget :-
    write('Enter task: '), read(Task),
    write('TOOLS BY BUDGET for '), write(Task), write(':'), nl,
    
    write('FREE: '),
    findall(Tool, ai_tool(Tool, Task, _, free), Free), write(Free), nl,
    
    write('FREEMIUM: '),
    findall(Tool, ai_tool(Tool, Task, _, freemium), Freemium), write(Freemium), nl,
    
    write('PAID: '),
    findall(Tool, ai_tool(Tool, Task, _, paid), Paid), write(Paid), nl.

% Rule 6: List all tools with their Criteria
list_all_tools :-
    write('ALL AI TOOLS:'), nl,
    forall(ai_tool(Tool, Task, Level, Budget),
           (write('- '), write(Tool), 
            write(' (Task: '), write(Task),
            write(', Level: '), write(Level),
            write(', Budget: '), write(Budget), write(')'), nl)).

% Rule 7: Show affordable tools (Excluding paid)
show_affordable_tools :-
    write('Enter task type to see Free/Freemium options: '), read(Task),
    write('Affordable options for '), write(Task), write(':'), nl,
    forall((ai_tool(Tool, Task, _, Budget), Budget \= paid),
           (write('- '), write(Tool), write(' ('), write(Budget), write(')'), nl)).

% Rule 8: Count tools for a specific task
count_tools_by_task :-
    write('Enter task type to count: '), read(Task),
    findall(Tool, ai_tool(Tool, Task, _, _), List),
    length(List, Count),
    write('Total number of tools for '), write(Task), write(' is: '), write(Count), nl.

% Rule 9: Quick guide based on budget only
quick_budget_guide :-
    write('Enter your budget (free/freemium/paid): '), read(Budget),
    write('Quick guide for '), write(Budget), write(' budget:'), nl,
    forall(task(T), 
           (   ai_tool(Tool, T, _, Budget)
           ->  write('- Best '), write(T), write(' tool: '), write(Tool), nl
           ;   write('- For '), write(T), write(': No direct match found'), nl
           )).