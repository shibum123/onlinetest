import moment from 'moment';
import React, { useState, useEffect } from 'react';
import './Practise.scss';

const Practise1 = () => {

    let i = 0;
    const [questions, setQuestions] = useState([]);
    const [showAnswer, setShowAnswer] = useState(false);
    const [disabled, setDisabled] = useState(false)
    const max = 12;
    const maxQuestions = 30

    useEffect(() => {
        const q = []

        while (i++ < maxQuestions) {
            const op1 = Math.random();
            const op2 = Math.random();
            const array = ['+', '-', '*'];
            const rand = array[Math.floor(Math.random() * array.length)];

            const op3 = op2 < 0.5 ? Math.random() * max : -Math.random() * max;
            q.push({
                operand1: op1 < 0.5 ? Math.random() * max : -Math.random() * max,
                operand2: rand === '-' && op3 < 0 ? Math.random() * max : rand == '*' ? -Math.random() * max : Math.random() * max,
                sign: rand,
                answer: null,
            })
        }

        setQuestions(q)
    }, [])

    const [timeLeft, setTimeLeft] = useState(maxQuestions / 12 * 60 * 1000);

    let timer;

    useEffect(() => {
        timer = setTimeout(() => {
            if ((timeLeft < 1000) || disabled) {
                clearTimeout(timer);
                setDisabled(true);
                onSubmit();
            } else {
                
                setTimeLeft(timeLeft - 1000);
            }
        }, 1000);
    });

    const onSubmit = () => {
        clearTimeout(timer);
        setDisabled(true);
        setShowAnswer(true)
    }

    const onChange = (event, index) => {
        const array = [...questions];
        array[index] = {
            ...array[index],
            answer: event.target.value
        };
        setQuestions(array)
    }

    let correctCount = 0;

    return <div className="practise">
        <h2>Practise</h2>
        
        <div className="practise__items">
            <div className="practise__timer">{moment.utc(timeLeft).format('HH:mm:ss')}</div>
        {
            questions.map((item, index) => {
                let correct = false;
                let correctAns = null

                if (item.sign === '-') {
                    correctAns = (Math.round(item.operand1) - Math.round(item.operand2)); // Todo Number
                } else if (item.sign === '*') {
                    correctAns = (Math.round(item.operand1) * Math.round(item.operand2));
                } else {
                    correctAns = (Math.round(item.operand1) + Math.round(item.operand2));
                }

                correct = correctAns == questions[index].answer

                if (correct) {
                    correctCount++;
                }


                return <div className="practise__container">
                    <div className="practise__quest-box">{index + 1}) </div>&nbsp;&nbsp;&nbsp;<div className="practise__quest-box">{Math.round(item.operand1)} </div><div className="practise__quest-box">{item.sign === '*' ? 'x' : item.sign}</div> <span className="practise__quest-box">{Math.round(item.operand2)}</span> &nbsp;&nbsp;= &nbsp;&nbsp;
                    { disabled && <input type="text" value={item.answer} onChange={(event) => onChange(event, index)} disabled  /> }
                    { !disabled && <input type="text" value={item.answer} onChange={(event) => onChange(event, index)}  /> }&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;
                    <div className="practise__quest-box">
                    {
                        correct && showAnswer &&
                        <i className="fa fa-check" style={{ 'font-size': '20px', 'color': 'green' }}></i>
                    }
                    {
                        !correct && showAnswer &&
                        <i className="fa fa-times" style={{ 'font-size': '20px', 'color': 'red' }}></i>
                    } </div>
                    <div className="practise__quest-box">
                    {showAnswer ? correctAns : ''}
                    </div>
                </div>
            })
        }
        </div>
        <br />
        <center><button className="btn btn-primary practise__button" onClick={onSubmit}>Submit</button></center>
        {showAnswer && <h2>Your Score is {correctCount} out of {questions.length}</h2>}
        <br/>

    </div>
}

export default Practise1;
