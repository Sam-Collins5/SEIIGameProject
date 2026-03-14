# All documents needed to satisfy the midterm requirements.

## Version management- 
    The version managemet is handled using the built in systmem in git and github.
    
## Change management; Bug tracking process
    Currently we are doign this fully by documenting our chat logs about different bugs we encounter, we usually hop on a call and troubleshoot till the  people involved know what went wrong.

## Architectural design
The architecture of the game follows a modular structure.
        
        Player System – controls character movement and interaction.
        Scene Management System – handles transitions between rooms.
        Battle / Challenge System – manages educational question encounters.
        UI System – displays questions, answers, and game information.
    
## Detailed design
        
        Player Controller- Handles player movement, collisions, and interaction with objects such as doors.
        
        Door System- Detects player interaction and transitions the player to another scene.
        
        Question System- Displays questions and answer options. Correct answers allow progression while incorrect answers trigger feedback.
        
        Battle Manager- Controls the logic behind challenge encounters between the player and an enemy.
    

## Database design
    N/A

## UI/UX Design
The user interface is designed to be simple and intuitive.

    Main game screen displaying the environment
    Question interface displaying challenge prompts
    Buttons for answer selection
    Visual feedback for correct and incorrect answers
