import React, { useState, useEffect } from 'react';
import { questions } from '../data/data.json';
import { useSelector, useDispatch } from 'react-redux';
import { setQuestions, setShowAnswers } from '../reducers/mainReducer';
import { OptionView } from './OptionView';

const Main = () => {

    const dispatch = useDispatch();

    const allQuestions = useSelector((state) => (shuffle(state.main.questions).filter((q, index) => [0, 4, 18, 28, 31, 36].indexOf(index) > -1))); // .filter(q => q.group === 2)

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

    const getMessage = (score) => {
        const percent = (score / allQuestions.length * 100).toFixed(2)
        if (percent < 50) {
            return 'You score is very poor! Go and Study again Kanishk!'
        } else if (percent < 70) {
            return 'You score is poor! Go and Study again Kanishk!'
        } else if (percent < 80) {
            return 'You score is fair! Go and Study again Kanishk!'
        } else if (percent < 90) {
            return 'You score is good! Study well Kanishk!'
        } else if (percent < 100) {
            return 'You score is very good! Try to get 100% Kanishk!'
        } else if (percent === 100) {
            return 'You score is excellen! Good job Kanishk!'
        }
    }


    return (
        <div className="container">
            {showAnswers && <h1>{getMessage(score)}</h1>}
            {showAnswers && <h1>{`Your score is: ${(score / allQuestions.length * 100).toFixed(2)} %`}</h1>}
            {showAnswers && (allQuestions.length > 0) ? allQuestions.map((question, index) => <OptionView question={question} index={index} />) : <OptionView question={allQuestions[currentPage]} index={currentPage} onChange={onChange} />}
            <div className="buttonContainer">
                <button className={currentPage <= 0 ? 'btn btn-primary disabled' : 'btn btn-primary'} onClick={onPrev}>&lt;&lt;</button>&nbsp;&nbsp;&nbsp;
                <button className={(currentPage < allQuestions.length - 1) ? 'btn btn-primary' : 'btn btn-primary disabled'} onClick={onNext}>&gt;&gt;</button>&nbsp;&nbsp;&nbsp;
                {currentPage === (allQuestions.length - 1) && !showAnswers && <button className="btn btn-primary" onClick={onSubmit}>Submit</button>}
            </div>
        </div>
    )
}

export default Main;