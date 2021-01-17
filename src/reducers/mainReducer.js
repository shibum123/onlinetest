export const SET_QUESTIONS = 'SET_QUESTIONS';
export const SET_SHOW_ANSWERS = 'SET_SHOW_ANSWERS';


const initialState = {
    questions: [],
    showAnswers: false
};

const shuffle = (array) => {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * i)
        const temp = array[i]
        array[i] = array[j]
        array[j] = temp
    }
    return array;
}

export default (state = initialState, action) => {
    switch (action.type) {
        case SET_QUESTIONS:
            const { questions } = action;
            const quest = shuffle(questions)
            return {
                ...state,
                quest
            };
        case SET_SHOW_ANSWERS:
            const { showAnswers } = action;
            return {
                ...state,
                showAnswers
            };
        default:
            return state;
    }
};

export const setQuestions = (
    questions
) => ({
    type: SET_QUESTIONS,
    questions
});

export const setShowAnswers = (
    showAnswers
) => ({
    type: SET_SHOW_ANSWERS,
    showAnswers
});