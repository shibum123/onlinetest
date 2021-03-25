import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useHistory } from 'react-router-dom';
import { setSelectedType } from  '../../reducers/mainReducer';

const Settings = () => {

    const history = useHistory();
    const dispatch = useDispatch();

    const selected = useSelector(state => state.main.selectedType)

    const onChange = event => {
        event.preventDefault();
        dispatch(setSelectedType(event.target.value));
    }

    const onSubmit = () => {
        history.push({
            pathname: '/test'
        });
    }

    const onSpellingsClick = () => {
        history.push({
            pathname: '/spellings'
        });
    }

    const onAddQuestions = () => {
        history.push({
            pathname: '/addquestions'
        });
    }

    const onPractiseClick = () => {
        history.push({
            pathname: '/practise-algebra'
        });
    }

    return <div className="container">
        <button className='btn btn-primary' onClick={onAddQuestions}>Add Questions</button> &nbsp;&nbsp;&nbsp;
        <button className='btn btn-primary' onClick={onSpellingsClick}>Spellings</button><br/><br/><br/>
        <button className='btn btn-primary' onClick={onPractiseClick}>Practise Algebra</button><br/><br/><br/>
        { selected !== 'all_questions'  && <input type="radio" name="radio" value="all_questions" onChange={onChange} /> }
        { selected === 'all_questions' && <input type="radio" name="radio" value="all_questions" onChange={onChange} checked/> }&nbsp;&nbsp;&nbsp;
        <label>All Questions</label><br />
        { selected !== 'filter_group1'  && <input type="radio" name="radio" value="filter_group1" onChange={onChange} /> }
        { selected === 'filter_group1' && <input type="radio" name="radio" value="filter_group1" onChange={onChange} checked/> }&nbsp;&nbsp;&nbsp;
        <label>Group 1</label><br />
        { selected !== 'filter_group2'  && <input type="radio" name="radio" value="filter_group2" onChange={onChange} /> }
        { selected === 'filter_group2' && <input type="radio" name="radio" value="filter_group2" onChange={onChange} checked/> }&nbsp;&nbsp;&nbsp;
        <label>Group 2</label><br />
        { selected !== 'filter_group3'  && <input type="radio" name="radio" value="filter_group3" onChange={onChange} /> }
        { selected === 'filter_group3' && <input type="radio" name="radio" value="filter_group3" onChange={onChange} checked/> }&nbsp;&nbsp;&nbsp;
        <label>Group 3</label><br />
        { selected !== 'filter_group4'  && <input type="radio" name="radio" value="filter_group4" onChange={onChange} /> }
        { selected === 'filter_group4' && <input type="radio" name="radio" value="filter_group4" onChange={onChange} checked/> }&nbsp;&nbsp;&nbsp;
        <label>Group 4</label><br />
        { selected !== 'filter_group5'  && <input type="radio" name="radio" value="filter_group5" onChange={onChange} /> }
        { selected === 'filter_group5' && <input type="radio" name="radio" value="filter_group5" onChange={onChange} checked/> }&nbsp;&nbsp;&nbsp;
        <label>Group 5</label><br />
        { selected !== 'filter_group6'  && <input type="radio" name="radio" value="filter_group6" onChange={onChange} /> }
        { selected === 'filter_group6' && <input type="radio" name="radio" value="filter_group6" onChange={onChange} checked/> }&nbsp;&nbsp;&nbsp;
        <label>Group 6</label><br />
        { selected !== 'filter_group7'  && <input type="radio" name="radio" value="filter_group7" onChange={onChange} /> }
        { selected === 'filter_group7' && <input type="radio" name="radio" value="filter_group7" onChange={onChange} checked/> }&nbsp;&nbsp;&nbsp;
        <label>Test 1</label><br />
        { selected !== 'most_wrong'  && <input type="radio" name="radio" value="most_wrong" onChange={onChange} /> }
        { selected === 'most_wrong' && <input type="radio" name="radio" value="most_wrong" onChange={onChange} checked/> }&nbsp;&nbsp;&nbsp;
        <label>Most Wrong</label><br /><br />
        <button className='btn btn-primary' onClick={onSubmit}>Select Questions</button>
    </div>
}

export default Settings;