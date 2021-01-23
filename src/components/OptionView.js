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

        return question.options.map((option, index) => {
            const selected = question.selectedOptions ? question.selectedOptions[index] : false;
            // alert(question.ans + ":" + option);
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
    }

    const getCorrect = (question) => question.ans.toString() === getResult(question).toString()

    return question ? <div className={showAnswers && !getCorrect(question) ? 'optionview__wrong' : 'optionview__correct'}>
        <div className="question" key={question.id} dangerouslySetInnerHTML={{__html: `Q${index + 1}: ${question.q}`}} />
        {
            question.img && <img src={question.img} />
        }
        <div className="options">{getOption(question)}</div>
    </div> : null;
}

export default OptionView;
