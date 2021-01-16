import React, { useState, useEffect } from 'react';
import { questions } from '../data/data.json';
import { useSelector, useDispatch } from 'react-redux';
import { setQuestions, setShowAnswers } from '../reducers/mainReducer';
import { OptionView } from './OptionView';

const Main = () => {

    const dispatch = useDispatch();
    const allQuestions = useSelector((state) => state.main.questions.filter(q => q.group === 2));

    useEffect(() => {
        dispatch(setQuestions(questions))
    }, []);

    let [currentPage, setCurrentPage] = useState(0);
    const showAnswers = useSelector(state => state.main.showAnswers);

    let [score, setScore] = useState(0);
    const [time, setTime] = useState(0);

    const onSubmit = (event) => {
        event.preventDefault();
        allQuestions.map(item => {
            if (item.ans.toString() === getResult(item).toString()) setScore(++score);
        });
        dispatch(setShowAnswers(true));
    }

    const getResult = (quest) => {
        const result = [];
        if (quest.selectedOptions) {
            quest.selectedOptions.map((item, index) => {
                if (item === true) result.push(quest.options[index]);
            });
        }
        return result;
    }

    const onNext = () => {
        if (currentPage < allQuestions.length - 1) setCurrentPage(++currentPage);
    }

    const onPrev = (event) => {
        event.preventDefault();
        if (currentPage > 0) setCurrentPage(--currentPage);
    }

    const onChange = (event, index) => {
        if (!allQuestions[currentPage].selectedOptions) allQuestions[currentPage].selectedOptions = [];
        allQuestions[currentPage].selectedOptions[index] = event.target.checked
    }


    return (
        <div className="container">
            { showAnswers && <h1>{`Your score is: ${score}`}</h1>}
            { showAnswers && (allQuestions.length > 0) ? allQuestions.map((question, index) => <OptionView question={question} index={index} />) : <OptionView question={allQuestions[currentPage]} index={currentPage} onChange={onChange}/>}
            <div className="buttonContainer">
                <button className={currentPage <= 0 ? 'btn btn-primary disabled' : 'btn btn-primary'} onClick={onPrev}>&lt;&lt;</button>&nbsp;&nbsp;&nbsp;
                <button className={(currentPage < allQuestions.length - 1) ? 'btn btn-primary' : 'btn btn-primary disabled'} onClick={onNext}>&gt;&gt;</button>&nbsp;&nbsp;&nbsp;
                {currentPage === (allQuestions.length - 1) && !showAnswers && <button className="btn btn-primary" onClick={onSubmit}>Submit</button>}
            </div>
        </div>
    )
}

export default Main;