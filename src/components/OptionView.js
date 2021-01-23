import React, { useEffect } from 'react';
import { useSelector } from 'react-redux';
import img from '../images/img1.png';
import './OptionView.scss';
import parse from 'html-react-parser';

export const OptionView = (props) => {

    const question = props.question;
    const index = props.index;
    const showAnswers = useSelector((state) => state.main.showAnswers);

    const getResult = (quest) => {
        const result = [];
        if (quest.selectedOptions) {
            quest.selectedOptions.map((item, index) => {
                if (item === true) result.push(quest.options[index]);
            });
        }
        return result;
    }

    const getOption = (question) => {

        const getOptionClass = (correctAnswer, showAnswers) => {
            if (correctAnswer && showAnswers) {
                return 'options-label correct'
            } else if (!correctAnswer && showAnswers) {
                return 'options-label wrong'
            } else if (!showAnswers) {
                return 'options-label'
            }
        }

        if (question.type === 'choice') {
            return question.options.map((option, index) => {
                const selected = question.selectedOptions ? question.selectedOptions[index] : false;
                const correctAnswer = question.ans === option;

                return <div key={`Q${question.id}OPT${index}`} >
                    <label className={getOptionClass(correctAnswer, showAnswers)}>
                        {selected && !showAnswers && <input id={`Q${question.id}OPT${index}`} type="checkbox" checked value={option} onChange={(event) => props.onChange(event, index)} />}
                        {!selected && !showAnswers && <input id={`Q${question.id}OPT${index}`} type="checkbox" value={option} onChange={(event) => props.onChange(event, index)} />}
                        {selected && showAnswers && <input id={`Q${question.id}OPT${index}`} type="checkbox" checked disabled value={option} />}
                        {!selected && showAnswers && <input id={`Q${question.id}OPT${index}`} type="checkbox" disabled value={option} />}
                    &nbsp;&nbsp;&nbsp;{parse(option)}</label>

                </div>
            })
        } else {
            if (!showAnswers) {
                return <input key={`Q${question.id}OPT0`} type="text" style={{ 'width': '200px' }} onChange={props.onTextChange} />
            } else {

                const correct = getCorrect(question);

                return <div key={`Q${question.id}OPT0`}>
                    <input type="text" style={{ 'width': '200px' }} disabled value={question.selectedOptions ? question.selectedOptions[0] : ''} />
                    &nbsp;&nbsp;&nbsp;
                    {question.ans}
                    &nbsp;&nbsp;&nbsp;
                    {
                        correct &&
                        <i className="fa fa-check" style={{ 'font-size': '20px', 'color': 'green' }}></i>
                    }
                    {
                        !correct &&
                        <i className="fa fa-times" style={{ 'font-size': '20px', 'color': 'red' }}></i>

                    }
                </div>
            }
        }
    }

    const getCorrect = (question) => {
        if (question.type === 'choice') {
            return question.ans.toString() === getResult(question).toString()
        } else {
            return question.selectedOptions ? (question.ans.toString() === question.selectedOptions.toString()) : false;
        }
    }

    return question ? <div className={showAnswers && !getCorrect(question) ? 'optionview__wrong' : 'optionview__correct'}>
        <div className="question" key={question.id} dangerouslySetInnerHTML={{ __html: `Q${index + 1}: ${question.q}` }} />
        {
            question.img && <img src={question.img} />
        }
        <div className="options">{getOption(question)}</div>
    </div> : null;
}

export default OptionView;
