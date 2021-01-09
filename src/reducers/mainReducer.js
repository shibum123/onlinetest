export const SET_QUESTIONS = 'SET_QUESTIONS';
export const SET_SHOW_ANSWERS = 'SET_SHOW_ANSWERS';


const initialState = {
    questions: [],
    showAnswers: false
};

export default (state = initialState, action) => {
    switch (action.type) {
        case SET_QUESTIONS:
            const { questions } = action;
            return {
                ...state,
                questions
            };
        case SET_SHOW_ANSWERS:
            const { showAnswers } = action;
            alert('setting')
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