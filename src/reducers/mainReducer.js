export const SET_QUESTIONS = 'SET_QUESTIONS';
export const SET_SHOW_ANSWERS = 'SET_SHOW_ANSWERS';
export const SET_SELECTED_TYPE = 'SET_SELECTED_TYPE';

const initialState = {
    questions: [],
    groupNames: {'group1': '', 'group2': '', 'group3': '', 'group4': '', 'group5': '20-Yr 5 Worksheet KAS-3B', 'group6': '20 - Yr 5 SHW - 09 B'},
    showAnswers: false,
    filteredQuestions: [],
    selectedType: 'all_questions'
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
            let filteredQuestions;
            if (state.selectedType === 'filter_group1') {
                filteredQuestions = questions.filter((q) => q.group === 1);
            } else if (state.selectedType === 'filter_group2') {
                filteredQuestions = questions.filter((q) => q.group === 2);
            } else if (state.selectedType === 'filter_group3') {
                filteredQuestions = questions.filter((q) => q.group === 3);
            } else if (state.selectedType === 'filter_group4') {
                filteredQuestions = questions.filter((q) => q.group === 4);
            } else if (state.selectedType === 'filter_group5') {
                filteredQuestions = questions.filter((q) => q.group === 5);
            } else if (state.selectedType === 'filter_group6') {
                filteredQuestions = questions.filter((q) => q.group === 6);
            } else if (state.selectedType === 'most_wrong') {
                filteredQuestions = questions.filter((q) => q.wrong_count > 0);
            } else {
                filteredQuestions = questions;
            }
            return {
                ...state,
                questions,
                filteredQuestions
            };
        case SET_SHOW_ANSWERS:
            const { showAnswers } = action;
            return {
                ...state,
                showAnswers
            };
        case SET_SELECTED_TYPE:
            const { selectedType } = action;
            return {
                ...state,
                selectedType
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

export const setSelectedType = (
    selectedType
) => ({
    type: SET_SELECTED_TYPE,
    selectedType
});