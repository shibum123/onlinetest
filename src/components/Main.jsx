import React, { Fragment, useState } from 'react';
import { questions } from '../data/data.json';

const Main = () => {

    let [currentPage, setCurrentPage] = useState(0);
    let [showAnswers, setShowAnswers] = useState(false);

    let [score, setScore] = useState(0);
    const [time, setTime] = useState(0);

    const onSubmit = () => {
        setShowAnswers(true);
        questions.map(item => {
            if(item.ans === getResult(item)) setScore(++score);
        })
    }

    const getResult = (quest) => {
        const result = []
        quest.selectedOptions.map((item, index) => {
            if(item === true) result.push(quest.options[index])
        });
        return result;
    }

    const onNext = () => {
        if (currentPage < questions.length - 1) setCurrentPage(++currentPage);
    }

    const onPrev = (event) => {
        event.preventDefault();
        if (currentPage > 0) setCurrentPage(--currentPage);
    }

    const onChange = (event, index) => {
        if (!questions[currentPage].selectedOptions) questions[currentPage].selectedOptions = [];
        questions[currentPage].selectedOptions[index] = event.target.checked
    }

    const getOption = (question) => {
        return question.options.map((option, index) => {
            const selected = question.selectedOptions ? question.selectedOptions[index] : false;
            const correctAnswer =  question.selectedOptions ? (question.ans === getResult(question)) : false;

            return <div key={`Q${question.id}OPT${index}`}>
                {selected && !showAnswers && <input id={`Q${question.id}OPT${index}`} type="checkbox" checked value={option} onChange={(event) => onChange(event, index)} />}
                {!selected && !showAnswers && <input id={`Q${question.id}OPT${index}`} type="checkbox" value={option} onChange={(event) => onChange(event, index)} />}
                {selected && showAnswers && <input id={`Q${question.id}OPT${index}`} type="checkbox" checked disabled value={option} onChange={(event) => onChange(event, index)} />}
                {!selected && showAnswers && <input id={`Q${question.id}OPT${index}`} type="checkbox" disabled value={option} onChange={(event) => onChange(event, index)} />}
                {correctAnswer && selected && showAnswers && <label for="index" className="options-label correct">{option}</label> }
                {!correctAnswer && selected && showAnswers && <label for="index" className="options-label wrong">{option}</label> }
                {(!selected || !showAnswers) && <label for="index" className="options-label">{option}</label> }
            </div>
        })
    }

    const renderContent = (question, index) => {
        return <div>
            <div className="question" key={question.id}>{`Q${index + 1}: ${question.q}`}</div>
                <div className="options">
                    {
                        getOption(question)
                    }
                </div>
            </div>
    }

    return (
        <div className="container">
        { showAnswers && <h1>{`Your score is: ${score}`}</h1> }
            { showAnswers ? questions.map((question, index) => renderContent(question, index)) : renderContent(questions[currentPage], currentPage) }
            <div className="buttonContainer">
                <button className="btn btn-primary" onClick={onPrev}>&lt;&lt;</button>&nbsp;&nbsp;&nbsp;
                <button className="btn btn-primary" onClick={onNext}>&gt;&gt;</button>&nbsp;&nbsp;&nbsp;
                { currentPage === (questions.length - 1) && !showAnswers && <button className="btn btn-primary" onClick={onSubmit}>Submit</button>}
            </div>
        </div>
    )
}

export default Main;